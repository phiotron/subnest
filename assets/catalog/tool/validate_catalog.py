#!/usr/bin/env python3
"""Validate assets/catalog/services.json against the catalog schema (see ../README.md).

Usage:  python assets/catalog/tool/validate_catalog.py [path/to/services.json]
Exit code 0 = valid, 1 = errors found. Standard library only.
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

CATEGORIES = {"video", "music", "ai", "storage", "software", "gaming",
              "reading", "health", "education", "telecom", "other"}
MARKETS = {"global", "vn"}
CYCLE_UNITS = {"day", "week", "month", "year"}
ZERO_DECIMAL = {"VND", "JPY", "KRW", "IDR"}  # currencies without minor units

SLUG = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
HEX = re.compile(r"^#[0-9A-Fa-f]{6}$")
DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
REGION = re.compile(r"^[A-Z]{2}$")
CURRENCY = re.compile(r"^[A-Z]{3}$")

TOP_KEYS = {"version", "updatedAt", "priceSurveyDate", "regions", "services"}
SERVICE_REQ = {"id", "name", "category", "color", "monogram", "aliases", "cancelUrl", "manageUrl", "plans"}
SERVICE_OPT = {"market", "note"}
PLAN_REQ = {"id", "name", "cycle", "prices"}
PLAN_OPT = {"members"}
PRICE_REQ = {"currency", "amount"}
PRICE_OPT = {"approx"}


def is_int(v):
    return isinstance(v, int) and not isinstance(v, bool)


def is_num(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool)


def check_keys(obj, req, opt, where, errors):
    if not isinstance(obj, dict):
        errors.append(f"{where}: must be an object")
        return False
    missing = req - obj.keys()
    extra = obj.keys() - req - opt
    if missing:
        errors.append(f"{where}: missing {sorted(missing)}")
    if extra:
        errors.append(f"{where}: unknown keys {sorted(extra)}")
    return not missing


def validate(data):
    errors, warnings = [], []
    if not check_keys(data, {"version", "updatedAt", "services"}, TOP_KEYS - {"version", "updatedAt", "services"}, "root", errors):
        return errors, warnings, []
    if not is_int(data["version"]) or data["version"] < 1:
        errors.append("root.version: must be an integer >= 1")
    for k in ("updatedAt", "priceSurveyDate"):
        if k in data and (not isinstance(data[k], str) or not DATE.match(data[k])):
            errors.append(f"root.{k}: must be YYYY-MM-DD")
    regions = data.get("regions", {})
    if not isinstance(regions, dict):
        errors.append("root.regions: must be an object {REGION: CURRENCY}")
        regions = {}
    services = data["services"]
    if not isinstance(services, list) or not services:
        errors.append("root.services: must be a non-empty array")
        return errors, warnings, []

    seen_ids = set()
    seen_look = {}
    for i, s in enumerate(services):
        where = f"services[{i}]"
        if not check_keys(s, SERVICE_REQ, SERVICE_OPT, where, errors):
            continue
        sid = s["id"]
        where = f"service '{sid}'"
        if not isinstance(sid, str) or not SLUG.match(sid):
            errors.append(f"{where}: id must be a lowercase slug")
        if sid in seen_ids:
            errors.append(f"{where}: duplicate id")
        seen_ids.add(sid)
        if not isinstance(s["name"], str) or not s["name"].strip():
            errors.append(f"{where}: name must be a non-empty string")
        if s["category"] not in CATEGORIES:
            errors.append(f"{where}: category '{s['category']}' not in {sorted(CATEGORIES)}")
        if "market" in s and s["market"] not in MARKETS:
            errors.append(f"{where}: market must be one of {sorted(MARKETS)}")
        if not isinstance(s["color"], str) or not HEX.match(s["color"]):
            errors.append(f"{where}: color '{s['color']}' is not #RRGGBB")
        mono = s["monogram"]
        if not isinstance(mono, str) or not (1 <= len(mono) <= 2) or mono.strip() != mono:
            errors.append(f"{where}: monogram must be 1-2 characters, no spaces")
        look = (str(s["color"]).upper(), mono)
        if look in seen_look:
            warnings.append(f"{where}: same color+monogram as '{seen_look[look]}' (tiles indistinguishable)")
        seen_look[look] = sid
        aliases = s["aliases"]
        if not isinstance(aliases, list) or not all(isinstance(a, str) and a.strip() for a in aliases):
            errors.append(f"{where}: aliases must be an array of non-empty strings")
        else:
            if any(a != a.lower() for a in aliases):
                errors.append(f"{where}: aliases must be lowercase")
            dup = [a for a, n in Counter(aliases).items() if n > 1]
            if dup:
                errors.append(f"{where}: duplicate aliases {dup}")
        for k in ("cancelUrl", "manageUrl"):
            v = s[k]
            if v is not None and (not isinstance(v, str) or not v.startswith("https://")):
                errors.append(f"{where}: {k} must be an https:// URL or null")
        if "note" in s and not isinstance(s["note"], str):
            errors.append(f"{where}: note must be a string")

        plans = s["plans"]
        if not isinstance(plans, list) or not plans:
            errors.append(f"{where}: plans must be a non-empty array")
            continue
        plan_ids = set()
        priced = 0
        for j, p in enumerate(plans):
            pw = f"{where}.plans[{j}]"
            if not check_keys(p, PLAN_REQ, PLAN_OPT, pw, errors):
                continue
            pw = f"{where}.plan '{p['id']}'"
            if not isinstance(p["id"], str) or not SLUG.match(p["id"]):
                errors.append(f"{pw}: id must be a lowercase slug")
            if p["id"] in plan_ids:
                errors.append(f"{pw}: duplicate plan id")
            plan_ids.add(p["id"])
            if not isinstance(p["name"], str) or not p["name"].strip():
                errors.append(f"{pw}: name must be a non-empty string")
            c = p["cycle"]
            if check_keys(c, {"unit", "count"}, set(), f"{pw}.cycle", errors):
                if c["unit"] not in CYCLE_UNITS:
                    errors.append(f"{pw}.cycle.unit must be one of {sorted(CYCLE_UNITS)}")
                if not is_int(c["count"]) or c["count"] < 1:
                    errors.append(f"{pw}.cycle.count must be an integer >= 1")
            if "members" in p and (not is_int(p["members"]) or p["members"] < 2):
                errors.append(f"{pw}: members must be an integer >= 2")
            prices = p["prices"]
            if not isinstance(prices, dict):
                errors.append(f"{pw}: prices must be an object")
                continue
            if prices:
                priced += 1
            for region, pr in prices.items():
                rw = f"{pw}.prices.{region}"
                if not REGION.match(region):
                    errors.append(f"{rw}: region must be ISO 3166-1 alpha-2 (e.g. VN, US)")
                if not check_keys(pr, PRICE_REQ, PRICE_OPT, rw, errors):
                    continue
                cur, amt = pr["currency"], pr["amount"]
                if not isinstance(cur, str) or not CURRENCY.match(cur):
                    errors.append(f"{rw}: currency must be ISO 4217 (e.g. VND, USD)")
                if not is_num(amt) or amt <= 0:
                    errors.append(f"{rw}: amount must be a number > 0")
                elif cur in ZERO_DECIMAL and not (is_int(amt) or float(amt).is_integer()):
                    errors.append(f"{rw}: {cur} amount must be a whole number")
                elif is_num(amt) and round(amt, 2) != amt:
                    errors.append(f"{rw}: amount has more than 2 decimals")
                if "approx" in pr and not isinstance(pr["approx"], bool):
                    errors.append(f"{rw}: approx must be a boolean")
                if region in regions and regions[region] != cur:
                    warnings.append(f"{rw}: currency {cur} differs from region default {regions[region]}")
        if priced == 0:
            errors.append(f"{where}: needs at least one plan with a price")
    return errors, warnings, services


def summary(services):
    cats = Counter(s.get("category") for s in services)
    markets = Counter(s.get("market", "global") for s in services)
    plans = [p for s in services for p in s.get("plans", [])]
    prices = [pr for p in plans for pr in p.get("prices", {}).values()]
    has_vn = sum(1 for s in services if any("VN" in p.get("prices", {}) for p in s.get("plans", [])))
    has_us = sum(1 for s in services if any("US" in p.get("prices", {}) for p in s.get("plans", [])))
    approx = sum(1 for pr in prices if pr.get("approx"))
    print(f"services: {len(services)}  plans: {len(plans)}  prices: {len(prices)} (approx: {approx})")
    print(f"market: " + ", ".join(f"{k}={v}" for k, v in sorted(markets.items())))
    print(f"services with VN price: {has_vn}  with US price: {has_us}")
    print("by category: " + ", ".join(f"{c}={cats.get(c, 0)}" for c in sorted(CATEGORIES)))


def main():
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "services.json"
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as e:
        print(f"ERROR: cannot read {path}: {e}")
        return 1
    errors, warnings, services = validate(data)
    for w in warnings:
        print(f"WARN  {w}")
    for e in errors:
        print(f"ERROR {e}")
    if services:
        summary(services)
    print("OK" if not errors else f"FAILED: {len(errors)} error(s)")
    return 0 if not errors else 1


if __name__ == "__main__":
    sys.exit(main())
