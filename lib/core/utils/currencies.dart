/// Currencies offered first in pickers (the full list comes from the rate provider).
const List<String> commonCurrencies = [
  'USD', 'VND', 'EUR', 'GBP', 'JPY', 'KRW', 'CNY', 'SGD', 'THB', 'AUD', 'CAD', 'HKD', 'TWD', 'MYR',
  'IDR', 'PHP', 'INR', 'CHF',
];

/// English display names; the UI session may replace with localized names.
const Map<String, String> currencyNames = {
  'VND': 'Vietnamese đồng',
  'USD': 'US dollar',
  'EUR': 'Euro',
  'GBP': 'British pound',
  'JPY': 'Japanese yen',
  'KRW': 'South Korean won',
  'CNY': 'Chinese yuan',
  'SGD': 'Singapore dollar',
  'THB': 'Thai baht',
  'AUD': 'Australian dollar',
  'CAD': 'Canadian dollar',
  'HKD': 'Hong Kong dollar',
  'TWD': 'New Taiwan dollar',
  'MYR': 'Malaysian ringgit',
  'IDR': 'Indonesian rupiah',
  'PHP': 'Philippine peso',
  'INR': 'Indian rupee',
  'CHF': 'Swiss franc',
};
