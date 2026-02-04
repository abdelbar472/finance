# Finance gRPC Testing Guide

## 🎯 Quick Start Testing

This guide covers all 4 endpoints of the Finance gRPC service:
1. **CreateTransaction** - Create income/expense transactions
2. **GetTransaction** - Get a specific transaction by ID
3. **ListTransactions** - List all transactions for a user
4. **GetBalance** - Get current balance for a user

---

## ✅ Prerequisites

1. **Start the server:**
   ```powershell
   go run server/main.go
   ```
   You should see: `Server listening on :50051 with reflection enabled`

2. **Server must be running** on `localhost:50051` before testing

---

## 🧪 Testing Options

### Option 1: Postman (Recommended for Manual Testing)

#### Setup
1. Open Postman
2. Click **New** → **gRPC Request**
3. **IMPORTANT Settings:**
   - Server URL: `localhost:50051`
   - Use TLS: ❌ **UNCHECKED** 
   - Server Reflection: ✅ **CHECKED**
4. Click **Connect**

#### Import Collection
1. File → Import
2. Select `tests/Finance_gRPC_Complete.postman_collection.json`
3. You'll get 28+ pre-built test cases organized in folders

#### Test All Endpoints Manually

**Test 1: CreateTransaction**
```json
{
  "user_id": "user123",
  "amount": 1500.00,
  "type": "income",
  "category": "salary",
  "description": "Monthly salary"
}
```
Method: `finance.FinanceService/CreateTransaction`

**Test 2: GetBalance**
```json
{
  "user_id": "user123"
}
```
Method: `finance.FinanceService/GetBalance`

**Test 3: ListTransactions**
```json
{
  "user_id": "user123"
}
```
Method: `finance.FinanceService/ListTransactions`

**Test 4: GetTransaction**
```json
{
  "id": "PASTE_ID_FROM_CREATE_RESPONSE"
}
```
Method: `finance.FinanceService/GetTransaction`

See [postman_tests.md](postman_tests.md) for detailed test cases.

---

### Option 2: Automated PowerShell Script (Recommended for Full Testing)

Run all 28+ tests automatically:

```powershell
cd tests
.\run_all_tests.ps1
```

This script tests:
- ✅ All 4 endpoints
- ✅ 3 income transactions (salary, freelance, investment)
- ✅ 5 expense transactions (rent, groceries, utilities, transportation, entertainment)
- ✅ Balance calculations
- ✅ Transaction listing
- ✅ 3 different users (user123, user456, user789)
- ✅ 6 edge cases (min/max amounts, empty fields, invalid IDs)
- ✅ 3 category variations
- ✅ Rapid sequential transactions
- ✅ Real-world monthly budget scenario

**Output includes:**
- ✅ Color-coded results
- ✅ Test summary table
- ✅ Expected vs actual values
- ✅ Pass/fail indicators

---

### Option 3: grpcurl (Command Line Testing)

#### Install grpcurl
```powershell
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```

#### Test All Endpoints

**1. List Services (verify server is running)**
```powershell
grpcurl -plaintext localhost:50051 list
```
Expected output:
```
finance.FinanceService
grpc.reflection.v1alpha.ServerReflection
```

**2. Test CreateTransaction**
```powershell
# Create income
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":1500.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"Monthly salary\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Create expense
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":500.00,\"type\":\"expense\",\"category\":\"rent\",\"description\":\"Monthly rent\"}' localhost:50051 finance.FinanceService/CreateTransaction
```

**3. Test GetBalance**
```powershell
grpcurl -plaintext -d '{\"user_id\":\"user123\"}' localhost:50051 finance.FinanceService/GetBalance
```
Expected: `{"balance": 1000}`

**4. Test ListTransactions**
```powershell
grpcurl -plaintext -d '{\"user_id\":\"user123\"}' localhost:50051 finance.FinanceService/ListTransactions
```
Expected: Array of transactions

**5. Test GetTransaction**
```powershell
# First, create a transaction and copy the ID
grpcurl -plaintext -d '{\"user_id\":\"test\",\"amount\":100.00,\"type\":\"income\",\"category\":\"bonus\",\"description\":\"Test\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Then use the ID (replace YOUR_ID)
grpcurl -plaintext -d '{\"id\":\"YOUR_ID\"}' localhost:50051 finance.FinanceService/GetTransaction
```

---

### Option 4: Go Client (Programmatic Testing)

Run the included client:
```powershell
go run client/main.go
```

This tests:
- CreateTransaction
- GetBalance
- ListTransactions

---

## 📊 Complete Test Matrix

| Endpoint | Test Cases | What It Tests |
|----------|-----------|---------------|
| **CreateTransaction** | 14 | Income types, expense types, categories, edge cases |
| **GetBalance** | 6 | Single user, multiple users, empty users |
| **ListTransactions** | 5 | Populated lists, empty lists, multiple users |
| **GetTransaction** | 3 | Valid ID, invalid ID, non-existent ID |

**Total: 28+ test cases**

---

## 🎯 Endpoint Test Details

### Endpoint 1: CreateTransaction

**Purpose:** Create a new income or expense transaction

**Test Cases:**
1. ✅ Income - Salary (5000.00)
2. ✅ Income - Freelance (1200.50)
3. ✅ Income - Investment (350.75)
4. ✅ Expense - Rent (1500.00)
5. ✅ Expense - Groceries (450.30)
6. ✅ Expense - Utilities (125.60)
7. ✅ Expense - Transportation (85.00)
8. ✅ Expense - Entertainment (75.50)
9. ✅ Edge Case - Minimum amount (0.01)
10. ✅ Edge Case - Large amount (999999.99)
11. ✅ Edge Case - Empty description
12. ✅ Category - Healthcare (250.00)
13. ✅ Category - Education (500.00)
14. ✅ Category - Savings (1000.00)

---

### Endpoint 2: GetBalance

**Purpose:** Calculate total income - total expenses for a user

**Test Cases:**
1. ✅ User123 - After multiple transactions
2. ✅ User456 - Single income and expense
3. ✅ User789 - Different amounts
4. ✅ Rapid Test User - Multiple small transactions
5. ✅ John Doe - Real-world monthly budget
6. ✅ Non-existent User - Should return 0.00

**Expected Results:**
| User | Income | Expenses | Balance |
|------|--------|----------|---------|
| user123 | ~1,007,551.25 | ~3,236.40 | ~1,004,314.85 |
| user456 | 3,500.00 | 800.00 | 2,700.00 |
| user789 | 2,000.00 | 500.00 | 1,500.00 |

---

### Endpoint 3: ListTransactions

**Purpose:** Get all transactions for a specific user

**Test Cases:**
1. ✅ User123 - Should return 8+ transactions
2. ✅ User456 - Should return 2 transactions
3. ✅ User789 - Should return 2 transactions
4. ✅ Rapid Test - Should return 5 transactions
5. ✅ Non-existent User - Should return empty array []

**Verification:**
- Each transaction has: id, user_id, amount, type, category, description, timestamp
- Transactions are only for requested user
- All transaction data is preserved correctly

---

### Endpoint 4: GetTransaction

**Purpose:** Retrieve a single transaction by its UUID

**Test Cases:**
1. ✅ Valid transaction ID - Returns full transaction object
2. ✅ Invalid transaction ID - Returns null/empty
3. ✅ Non-existent ID - Returns null/empty

**Steps to Test:**
1. Create a transaction using CreateTransaction
2. Copy the `id` from the response
3. Use that ID in GetTransaction request
4. Verify the response matches the original transaction

---

## 🔍 Verification Checklist

After running tests, verify:

- [ ] CreateTransaction returns unique UUID for each transaction
- [ ] CreateTransaction returns timestamp
- [ ] GetBalance correctly calculates (income - expenses)
- [ ] GetBalance returns 0.00 for non-existent users
- [ ] ListTransactions returns only transactions for the requested user
- [ ] ListTransactions returns empty array for non-existent users
- [ ] GetTransaction returns correct transaction when ID is valid
- [ ] GetTransaction returns null for invalid/non-existent IDs
- [ ] Multiple users' data is isolated (no cross-contamination)
- [ ] Concurrent transactions are handled safely

---

## 📝 Sample Test Workflow

1. **Start Server**
   ```powershell
   go run server/main.go
   ```

2. **Run Full Test Suite**
   ```powershell
   cd tests
   .\run_all_tests.ps1
   ```

3. **Verify Output**
   - Check that all tests pass
   - Review the test summary table
   - Verify balances match expectations

4. **Manual Testing in Postman (Optional)**
   - Import the collection
   - Run individual tests
   - Verify responses

5. **Test Individual Endpoints**
   ```powershell
   # Quick manual tests
   grpcurl -plaintext -d '{\"user_id\":\"test1\",\"amount\":100,\"type\":\"income\",\"category\":\"test\",\"description\":\"Test\"}' localhost:50051 finance.FinanceService/CreateTransaction
   
   grpcurl -plaintext -d '{\"user_id\":\"test1\"}' localhost:50051 finance.FinanceService/GetBalance
   ```

---

## 🐛 Troubleshooting

### Server Not Starting
```
Error: listen tcp :50051: bind: address already in use
```
**Solution:** Kill existing process on port 50051
```powershell
Get-Process | Where-Object {$_.ProcessName -eq "main"} | Stop-Process
```

### Postman TLS Error
```
Error: SSL routines:OPENSSL_internal:WRONG_VERSION_NUMBER
```
**Solution:** **Uncheck "Use TLS"** in Postman

### grpcurl Not Found
```
grpcurl: command not found
```
**Solution:** 
```powershell
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
# Add %GOPATH%\bin to PATH
```

### Server Reflection Not Working
```
Error: Server does not support reflection
```
**Solution:** Verify server code has:
```go
reflection.Register(s)
```

---

## 📚 Additional Resources

- **Detailed Test Cases:** [postman_tests.md](postman_tests.md)
- **Postman Collection:** [Finance_gRPC_Complete.postman_collection.json](Finance_gRPC_Complete.postman_collection.json)
- **Automated Tests:** [run_all_tests.ps1](run_all_tests.ps1)
- **Main README:** [../README.md](../README.md)

---

## 🎉 Success Criteria

All tests pass when:
- ✅ Server starts without errors
- ✅ All 4 endpoints respond correctly
- ✅ Balance calculations are accurate
- ✅ Transactions are properly isolated per user
- ✅ Edge cases handled gracefully
- ✅ Invalid inputs return appropriate responses

**Happy Testing! 🚀**
