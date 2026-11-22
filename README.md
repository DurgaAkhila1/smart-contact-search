# Smart Contact Search

A type-ahead search for Salesforce that finds Contacts by **name, email, phone or account name** as you type, with clickable results that open the record.

![Apex](https://img.shields.io/badge/Apex-00A1E0?logo=salesforce&logoColor=white) ![LWC](https://img.shields.io/badge/LWC-032D60?logo=salesforce&logoColor=white)

> 🚧 **In progress:** the Apex search layer and its tests are done. The Lightning Web Component UI is next.

## Features
- Searches **300 ms after you stop typing** (debounced), so the server isn't called on every keystroke
- Searches four fields at once, including the parent Account name
- `lightning-datatable` with email and phone links, and click-to-open with `NavigationMixin`
- Safe by design: bind variables and `WITH USER_MODE`

## How it works
| Layer | File | What it does |
|---|---|---|
| Apex | `ContactSearchController.cls` | A SOQL `LIKE` query using bind variables. Requires at least 2 characters and returns at most 50 rows. |
| LWC | `contactSearch` *(coming next)* | Debounced type-ahead input and results table. |
| Tests | `ContactSearchControllerTest.cls` | Tests name, email, phone and account matches, short or blank input, and an injection attempt. |

## Deploy
```bash
sf org login web --alias dev
sf project deploy start --source-dir force-app --target-org dev
sf apex run test --class-names ContactSearchControllerTest --result-format human --target-org dev
```

## Interview talking points
- **What is debouncing?** It means waiting until the user pauses typing before searching. This cuts server calls and keeps results from flickering.
- **How do you prevent SOQL injection?** With bind variables (`:pattern`), user input is never joined into the query text, so quotes can't change the query. The test proves it.
- **SOQL `LIKE` or SOSL?** `LIKE` is exact and works right away, even in tests. SOSL is faster across many objects but uses a search index, and in tests it needs `Test.setFixedSearchResults`.
- **Why flatten `Account.Name`?** `lightning-datatable` can't show nested fields directly, so the JS maps it to `accountName`.
