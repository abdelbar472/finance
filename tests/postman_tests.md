# Complete Postman Test Suite for Finance gRPC Service

## Postman Configuration

### Connection Settings
- **Server URL**: `localhost:50051`
- **Use TLS**: ❌ **UNCHECKED** (very important!)
- **Server Reflection**: ✅ **CHECKED**
- **Service**: `finance.FinanceService`

---

## Test Suite Overview

This test suite covers:
- ✅ Income transactions (3 tests)
- ✅ Expense transactions (5 tests)
- ✅ Balance calculations (3 tests)
- ✅ Transaction listing (2 tests)
- ✅ Multiple users (6 tests)
- ✅ Edge cases (6 tests)
- ✅ Category variations (3 tests)

**Total: 28+ test cases**

---

## Test 1: Create Income Transactions

### 1.1 Monthly Salary
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 5000.00,
  "type": "income",
  "category": "salary",
  "description": "Monthly salary - January 2024"
}
```
**Expected Response**: Transaction object with generated `id` and `timestamp`

---

### 1.2 Freelance Income
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 1200.50,
  "type": "income",
  "category": "freelance",
  "description": "Web development project"
}
```

---

### 1.3 Investment Returns
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 350.75,
  "type": "income",
  "category": "investment",
  "description": "Stock dividends Q1"
}
```

---

## Test 2: Create Expense Transactions

### 2.1 Monthly Rent
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 1500.00,
  "type": "expense",
  "category": "rent",
  "description": "Monthly apartment rent"
}
```

---

### 2.2 Groceries
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 450.30,
  "type": "expense",
  "category": "groceries",
  "description": "Weekly grocery shopping"
}
```

---

### 2.3 Utilities
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 125.60,
  "type": "expense",
  "category": "utilities",
  "description": "Electric and water bills"
}
```

---

### 2.4 Transportation
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 85.00,
  "type": "expense",
  "category": "transportation",
  "description": "Monthly bus pass"
}
```

---

### 2.5 Entertainment
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 75.50,
  "type": "expense",
  "category": "entertainment",
  "description": "Movie tickets and dinner"
}
```

---

## Test 3: Get Balance

### 3.1 User123 Balance
**Method**: `finance.FinanceService/GetBalance`
```json
{
  "user_id": "user123"
}
```
**Expected Balance**: `4314.85` (6551.25 income - 2236.40 expenses)

---

## Test 4: List All Transactions

### 4.1 List User123 Transactions
**Method**: `finance.FinanceService/ListTransactions`
```json
{
  "user_id": "user123"
}
```
**Expected**: Array of 8 transactions with all details

---

## Test 5: Get Specific Transaction

### 5.1 Get Transaction by ID
**Method**: `finance.FinanceService/GetTransaction`

**Steps:**
1. Create a transaction (use any test above)
2. Copy the `id` from the response
3. Use that ID in this request:

```json
{
  "id": "PASTE_TRANSACTION_ID_HERE"
}
```
**Expected**: Single transaction object matching the ID

---

## Test 6: Multiple Users

### 6.1 Create User456 - Income
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user456",
  "amount": 3500.00,
  "type": "income",
  "category": "salary",
  "description": "User456 monthly salary"
}
```

---

### 6.2 Create User456 - Expense
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user456",
  "amount": 800.00,
  "type": "expense",
  "category": "rent",
  "description": "User456 rent payment"
}
```

---

### 6.3 Get User456 Balance
**Method**: `finance.FinanceService/GetBalance`
```json
{
  "user_id": "user456"
}
```
**Expected Balance**: `2700.00`

---

### 6.4 Create User789 - Income
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user789",
  "amount": 2000.00,
  "type": "income",
  "category": "salary",
  "description": "User789 part-time income"
}
```

---

### 6.5 Create User789 - Expense
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user789",
  "amount": 500.00,
  "type": "expense",
  "category": "shopping",
  "description": "Electronics purchase"
}
```

---

### 6.6 Get User789 Balance
**Method**: `finance.FinanceService/GetBalance`
```json
{
  "user_id": "user789"
}
```
**Expected Balance**: `1500.00`

---

## Test 7: Edge Cases

### 7.1 Minimum Amount
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 0.01,
  "type": "income",
  "category": "test",
  "description": "Minimum amount test"
}
```
**Expected**: Transaction created successfully

---

### 7.2 Large Amount
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 999999.99,
  "type": "income",
  "category": "test",
  "description": "Large amount test"
}
```
**Expected**: Transaction created successfully

---

### 7.3 Empty Description
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 100.00,
  "type": "income",
  "category": "bonus",
  "description": ""
}
```
**Expected**: Transaction created with empty description

---

### 7.4 Special Characters in Description
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 50.00,
  "type": "expense",
  "category": "food",
  "description": "Coffee @ Café \"Le Noir\" - €5.50"
}
```
**Expected**: Transaction created with special characters preserved

---

### 7.5 Non-existent User Balance
**Method**: `finance.FinanceService/GetBalance`
```json
{
  "user_id": "nonexistent_user_xyz"
}
```
**Expected Balance**: `0.00`

---

### 7.6 Empty Transaction List
**Method**: `finance.FinanceService/ListTransactions`
```json
{
  "user_id": "nonexistent_user_xyz"
}
```
**Expected**: Empty transactions array `[]`

---

### 7.7 Invalid Transaction ID
**Method**: `finance.FinanceService/GetTransaction`
```json
{
  "id": "invalid-transaction-id-12345-xyz"
}
```
**Expected**: `null` or empty response

---

## Test 8: Category Variations

### 8.1 Healthcare Expense
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 250.00,
  "type": "expense",
  "category": "healthcare",
  "description": "Doctor visit and medications"
}
```

---

### 8.2 Education Expense
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 500.00,
  "type": "expense",
  "category": "education",
  "description": "Online course subscription"
}
```

---

### 8.3 Savings/Interest Income
**Method**: `finance.FinanceService/CreateTransaction`
```json
{
  "user_id": "user123",
  "amount": 1000.00,
  "type": "income",
  "category": "savings",
  "description": "Interest from savings account"
}
```

---

## Test 9: Rapid Sequential Transactions

### 9.1-9.5 Create 5 Quick Transactions
Run these **5 times** in quick succession:

**Transaction 1:**
```json
{"user_id":"rapid_test","amount":10.00,"type":"expense","category":"food","description":"Coffee #1"}
```

**Transaction 2:**
```json
{"user_id":"rapid_test","amount":15.00,"type":"expense","category":"food","description":"Coffee #2"}
```

**Transaction 3:**
```json
{"user_id":"rapid_test","amount":12.50,"type":"expense","category":"food","description":"Coffee #3"}
```

**Transaction 4:**
```json
{"user_id":"rapid_test","amount":20.00,"type":"expense","category":"food","description":"Lunch"}
```

**Transaction 5:**
```json
{"user_id":"rapid_test","amount":8.75,"type":"expense","category":"food","description":"Snack"}
```

### 9.6 Verify All Created
**Method**: `finance.FinanceService/ListTransactions`
```json
{
  "user_id": "rapid_test"
}
```
**Expected**: 5 transactions in the list

### 9.7 Verify Balance
**Method**: `finance.FinanceService/GetBalance`
```json
{
  "user_id": "rapid_test"
}
```
**Expected Balance**: `-66.25` (all expenses, no income)

---

## Test 10: Real-World Scenario

### Complete Monthly Budget Test

**Step 1: Add Income Sources**
```json
{"user_id":"john_doe","amount":5000.00,"type":"income","category":"salary","description":"January Salary"}
```
```json
{"user_id":"john_doe","amount":500.00,"type":"income","category":"freelance","description":"Side project"}
```

**Step 2: Add Fixed Expenses**
```json
{"user_id":"john_doe","amount":1200.00,"type":"expense","category":"rent","description":"Monthly rent"}
```
```json
{"user_id":"john_doe","amount":150.00,"type":"expense","category":"utilities","description":"Utilities"}
```
```json
{"user_id":"john_doe","amount":100.00,"type":"expense","category":"transportation","description":"Metro pass"}
```

**Step 3: Add Variable Expenses**
```json
{"user_id":"john_doe","amount":400.00,"type":"expense","category":"groceries","description":"Monthly groceries"}
```
```json
{"user_id":"john_doe","amount":200.00,"type":"expense","category":"entertainment","description":"Entertainment"}
```
```json
{"user_id":"john_doe","amount":150.00,"type":"expense","category":"healthcare","description":"Health insurance"}
```

**Step 4: Check Final Balance**
```json
{"user_id":"john_doe"}
```
**Expected Balance**: `3300.00` (5500 income - 2200 expenses)

**Step 5: Review All Transactions**
```json
{"user_id":"john_doe"}
```

---

## Expected Results Summary

| Test Category | User ID | Expected Income | Expected Expenses | Expected Balance |
|--------------|---------|-----------------|-------------------|------------------|
| Basic Tests | user123 | 1,007,551.25 | 3,236.40 | 1,004,314.85 |
| User 456 | user456 | 3,500.00 | 800.00 | 2,700.00 |
| User 789 | user789 | 2,000.00 | 500.00 | 1,500.00 |
| Rapid Test | rapid_test | 0.00 | 66.25 | -66.25 |
| John Doe | john_doe | 5,500.00 | 2,200.00 | 3,300.00 |

---

## Tips for Testing in Postman

1. **Save Responses**: Click on response → Save as Example
2. **Use Variables**: Create environment variables for common user IDs
3. **Test Scripts**: Add assertions in Postman Tests tab:
   ```javascript
   pm.test("Status is OK", function() {
       pm.expect(pm.response.to.have.status(0));
   });
   
   pm.test("Transaction has ID", function() {
       var jsonData = pm.response.json();
       pm.expect(jsonData).to.have.property('id');
   });
   ```

4. **Chain Requests**: Use the transaction ID from one request in another
5. **Collection Runner**: Run all tests sequentially
6. **Monitor**: Set up monitors to run tests periodically

---

## Common Issues & Solutions

### Issue 1: Connection Error
**Error**: "No connection established"
**Solution**: Make sure server is running (`go run server/main.go`)

### Issue 2: TLS Error
**Error**: "SSL routines:OPENSSL_internal:WRONG_VERSION_NUMBER"
**Solution**: **Uncheck "Use TLS"** in Postman settings

### Issue 3: Service Not Found
**Error**: "Service not found"
**Solution**: Ensure "Use Server Reflection" is **checked**

### Issue 4: Invalid Response
**Error**: Response doesn't match expected format
**Solution**: Check that server code matches proto definitions

---

## Next Steps

After completing these tests:
1. Save successful tests as examples
2. Export collection for team sharing
3. Create automated test scripts
4. Set up monitoring for production
5. Add performance tests with load testing tools

---

**Happy Testing! 🚀**
