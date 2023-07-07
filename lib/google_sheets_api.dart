import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = {
    "type": "service_account",
    "project_id": "tidy-visitor-392007",
    "private_key_id": "08833511c4c47b5f79bbe084716780bcc7a46e26",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCz3lSl6QMY6mUc\nadrzT4g74Ha0jrVXrs3nBCTvWuz7K+AyF1tJ4SmpwdnRD9tUzzZfJhO9W1SIiW6V\nkiOYO9nJlIGYs9Etu3iLJRiMG8/OaphqWSuY1ssqMYbRh1jZ5FlAUUIXYIJekEXd\n97b+4ZIeERtAoGIgGirLLRh6AxNJo7vHH+M1PKAmaGtRc/CwOUqNjBjhf0RsUvlZ\nPL0ClSZHNDImf7xFH7iz1qtXAS2DrshIIkXVmt/TJuUT4xLDrwFoORv53d89yZYA\nkmrR7w7hOGrsENJyBpoZHlIQSjsJwGFD8IqmWHdvZm5DAz01N/usQxSNp9orngxJ\nFvxZZL6FAgMBAAECggEAQR2MfHGyFtuIVjR2ON5CfhbBMpV1TfRxAyCLdIFwyG82\nXzv4ZvMWH6gXgCli6D2JvAFvZP5CyJkkSQ6aRzrnmaPjFNKIOCultI3t6I8K+Hm7\nisiUUWT1MOW0HneGsX8K1o90Qz1DhRNqz7QlcflcafkcahWF4IRImLxPH6CsY1w/\ncESPK98SdhHDO3PhV/Fzzzfj4uRhstjNcATGEG7q/hyC6ieBFEfOHWTpUnxrhYnN\n6wl0/Xm1hyeSh9SDS8qndJk4kHAbNnW1+7El0PBBUywTtYpUY2hL8EgIOnHbrQ1e\nfuanoeNeWSIuGbqR8nX99LAOIZar+SBunc7iEPKDwwKBgQD5pmwvL58rxS7Lf08+\nih91EQa2ytH/aaCvNu5cOzmJQp1/+NfL0L9fDoKHqEz4Hh2qRjvAsMJuYvAEKPsC\nx7fWZ9tu5xtI3HxHmaC+1BpyVJdBuadTYIZWZIiySN9zwvztGY68Vn2F+VQPMDpE\n8wwiDK5ubmufLVcMkOLxBWvn7wKBgQC4cYfMjc4HJ9tzXQmTxXISjQ9gV8rEx13/\n9EM7IqRh53dYXCVcUec/ta+nMWmOrgCmOn2JqQm4q6aCv40ugC1HDYtKE/d9UybQ\nMnAnLlChPQg9ZQnpyPqaooRM8ZxbhxUpP0O+kDfSV7VLLAxUj9bEDVOQq3cbGDZa\nQwttJbVsywKBgQCaNEsExnSaE70445VuOuD9bZvpEtSt4G/papPHEqoSd7xTjMC2\n22Up8Qt9gd6xL+EBCUrlVglzJ9e7qhiJ+hU68YHgOg5nbhGyJFnfJaKEVm3roiKR\n5MB14rlw7oRfu+SBC9VXzlDQjVZ330FOz5YB/jVMbxY5B0eKsoALgl7JrwKBgEJU\nygK9iLe4FMrzTatwGaskQcBjMk/8ZwjSvo740WdIR/pmASWnauPVolsdgRnH6AHg\nDR/Bw/Y+/P4Oh2aOwDnKXCqC7cGLcuzzBrSAiozCF0GFIcCK/902zx+g0Jt2BB02\nXFWfJgQmeNOU/sY2iIUvSbtAfvAmj/18GRLiudFrAoGAB3yy2VBZqX/Dm6pZxChE\nldn6nfqaargbLVHaqsGE7ItICsP7pdw/sTcatq0OOH0kr799LnR+Z41G+2hOPaWN\nXSTFHrgWvpqhWdA5EPBu+GdWW2r7DUSshtWG23Qm3kByv1t9/1HcXSYzAlN3DttG\nL2z2Lfpe1bhBn7XzVBs0PSE=\n-----END PRIVATE KEY-----\n",
    "client_email": "gsheets@tidy-visitor-392007.iam.gserviceaccount.com",
    "client_id": "115839476523197464903",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40tidy-visitor-392007.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1a2dTgw-h8Sx8MwdVGfMRr9ycLpg6pQQzfsNxHqMhumA';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
