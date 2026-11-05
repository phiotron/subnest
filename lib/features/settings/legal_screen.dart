import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import 'legal_texts.dart';

enum LegalDoc { privacy, terms }

/// Text of [doc] in the app language (VI for `vi`, English otherwise).
String legalText(LegalDoc doc, String localeName) {
  final vi = localeName.startsWith('vi');
  return switch (doc) {
    LegalDoc.privacy => vi ? LegalTexts.privacyVi : LegalTexts.privacyEn,
    LegalDoc.terms => vi ? LegalTexts.termsVi : LegalTexts.termsEn,
  };
}

/// In-app copy of the privacy policy / terms (S-13: the policy is reachable inside the app even
/// before a public URL exists, and offline). Renders the small Markdown subset of store/legal.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  static Route<void> route(LegalDoc doc) => MaterialPageRoute(builder: (_) => LegalScreen(doc: doc));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final blocks = LegalMarkdown.parse(legalText(doc, l.localeName));
    return Scaffold(
      appBar: AppTopBar(title: doc == LegalDoc.privacy ? l.settingsPrivacyPolicy : l.settingsTerms),
      body: SafeArea(
        top: false,
        child: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s8),
            children: [for (final b in blocks) _Block(b)],
          ),
        ),
      ),
    );
  }
}

enum LegalBlockKind { title, heading, paragraph, bullet, numbered }

class LegalBlock {
  const LegalBlock(this.kind, this.text, {this.number});

  final LegalBlockKind kind;

  /// Inline Markdown (`**bold**`, `[text](href)`) still in place.
  final String text;
  final String? number;
}

/// Parser for the Markdown used in store/legal: `#`/`##` headings, paragraphs (hard-wrapped
/// lines joined), `- ` bullets and `1. ` numbered items with indented continuation lines.
abstract final class LegalMarkdown {
  static final _numbered = RegExp(r'^(\d+)\.\s+(.*)$');

  static List<LegalBlock> parse(String md) {
    final out = <LegalBlock>[];
    LegalBlockKind? kind;
    String? number;
    final buf = <String>[];

    void flush() {
      if (kind != null && buf.isNotEmpty) out.add(LegalBlock(kind!, buf.join(' '), number: number));
      kind = null;
      number = null;
      buf.clear();
    }

    for (final raw in md.replaceAll('\r\n', '\n').split('\n')) {
      final line = raw.trimRight();
      final t = line.trimLeft();
      if (t.isEmpty) {
        flush();
      } else if (t.startsWith('## ')) {
        flush();
        out.add(LegalBlock(LegalBlockKind.heading, t.substring(3).trim()));
      } else if (t.startsWith('# ')) {
        flush();
        out.add(LegalBlock(LegalBlockKind.title, t.substring(2).trim()));
      } else if (t.startsWith('- ')) {
        flush();
        kind = LegalBlockKind.bullet;
        buf.add(t.substring(2).trim());
      } else if (_numbered.hasMatch(t) && line == t) {
        flush();
        final m = _numbered.firstMatch(t)!;
        kind = LegalBlockKind.numbered;
        number = m.group(1);
        buf.add(m.group(2)!.trim());
      } else {
        // Continuation of a list item (indented) or of a paragraph.
        if (kind == null || (line == t && kind != LegalBlockKind.paragraph)) {
          flush();
          kind = LegalBlockKind.paragraph;
        }
        buf.add(t);
      }
    }
    flush();
    return out;
  }

  static final _inline = RegExp(r'\*\*(.+?)\*\*|\[(.+?)\]\((.+?)\)');

  /// Inline spans: bold for `**…**`; a link keeps only its text (the store pages link to each
  /// other; inside the app both documents are one row apart in Settings).
  static List<InlineSpan> spans(String text, TextStyle bold) {
    final out = <InlineSpan>[];
    var i = 0;
    for (final m in _inline.allMatches(text)) {
      if (m.start > i) out.add(TextSpan(text: text.substring(i, m.start)));
      out.add(m.group(1) != null ? TextSpan(text: m.group(1), style: bold) : TextSpan(text: m.group(2)));
      i = m.end;
    }
    if (i < text.length) out.add(TextSpan(text: text.substring(i)));
    return out;
  }
}

class _Block extends StatelessWidget {
  const _Block(this.block);

  final LegalBlock block;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final body = AppType.body.copyWith(color: c.ink);
    final bold = body.copyWith(fontWeight: FontWeight.w600);
    Widget rich(TextStyle style) => Text.rich(TextSpan(style: style, children: LegalMarkdown.spans(block.text, bold)));
    switch (block.kind) {
      case LegalBlockKind.title:
        return Padding(
          padding: const EdgeInsets.only(top: AppSpace.s2, bottom: AppSpace.s3),
          child: Semantics(
            header: true,
            child: Text(block.text, style: AppType.title.copyWith(color: c.ink)),
          ),
        );
      case LegalBlockKind.heading:
        return Padding(
          padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
          child: Semantics(
            header: true,
            child: Text(block.text, style: AppType.titleSm.copyWith(color: c.ink)),
          ),
        );
      case LegalBlockKind.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s3),
          child: rich(body),
        );
      case LegalBlockKind.bullet:
      case LegalBlockKind.numbered:
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpace.s5,
                child: Text(block.kind == LegalBlockKind.bullet ? '•' : '${block.number}.', style: body),
              ),
              Expanded(child: rich(body)),
            ],
          ),
        );
    }
  }
}
