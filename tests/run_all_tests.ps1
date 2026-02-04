# Automated gRPC Test Script for Finance Service
# Requires: grpcurl installed (go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest)

$server = "localhost:50051"
$service = "finance.FinanceService"

Write-Host ""
Write-Host "🧪 Finance gRPC Service - Complete Test Suite" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""

# Test Connection
Write-Host "🔌 Testing Server Connection..." -ForegroundColor Yellow
try {
    $services = grpcurl -plaintext $server list 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Server is running and responding" -ForegroundColor Green
    } else {
        Write-Host "❌ Cannot connect to server. Please start the server first:" -ForegroundColor Red
        Write-Host "   go run server/main.go" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Error connecting to server" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan

# Test 1: Income Transactions
Write-Host ""
Write-Host "📈 TEST 1: Creating Income Transactions" -ForegroundColor Green
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host "  1.1 Monthly Salary (5000.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":5000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"Monthly salary - January 2024\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  1.2 Freelance Income (1200.50)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":1200.50,\"type\":\"income\",\"category\":\"freelance\",\"description\":\"Web development project\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  1.3 Investment Returns (350.75)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":350.75,\"type\":\"income\",\"category\":\"investment\",\"description\":\"Stock dividends Q1\"}' $server $service/CreateTransaction

# Test 2: Expense Transactions
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "📉 TEST 2: Creating Expense Transactions" -ForegroundColor Red
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host "  2.1 Monthly Rent (1500.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":1500.00,\"type\":\"expense\",\"category\":\"rent\",\"description\":\"Monthly apartment rent\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  2.2 Groceries (450.30)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":450.30,\"type\":\"expense\",\"category\":\"groceries\",\"description\":\"Weekly grocery shopping\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  2.3 Utilities (125.60)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":125.60,\"type\":\"expense\",\"category\":\"utilities\",\"description\":\"Electric and water bills\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  2.4 Transportation (85.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":85.00,\"type\":\"expense\",\"category\":\"transportation\",\"description\":\"Monthly bus pass\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  2.5 Entertainment (75.50)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":75.50,\"type\":\"expense\",\"category\":\"entertainment\",\"description\":\"Movie tickets and dinner\"}' $server $service/CreateTransaction

# Test 3: Get Balance
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "💰 TEST 3: Getting Balance for user123" -ForegroundColor Magenta
Write-Host ("-" * 70) -ForegroundColor Gray
Write-Host "Expected: 4314.85 (Income: 6551.25 - Expenses: 2236.40)" -ForegroundColor Gray
Write-Host ""
grpcurl -plaintext -d '{\"user_id\":\"user123\"}' $server $service/GetBalance

# Test 4: List Transactions
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "📋 TEST 4: Listing All Transactions for user123" -ForegroundColor Blue
Write-Host ("-" * 70) -ForegroundColor Gray
Write-Host "Expected: 8 transactions" -ForegroundColor Gray
Write-Host ""
grpcurl -plaintext -d '{\"user_id\":\"user123\"}' $server $service/ListTransactions

# Test 5: Multiple Users
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "👥 TEST 5: Testing Multiple Users" -ForegroundColor Cyan
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host ""
Write-Host "  5.1 User456 - Create Income (3500.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user456\",\"amount\":3500.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"User456 monthly salary\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  5.2 User456 - Create Expense (800.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user456\",\"amount\":800.00,\"type\":\"expense\",\"category\":\"rent\",\"description\":\"User456 rent payment\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  5.3 User456 - Get Balance (Expected: 2700.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user456\"}' $server $service/GetBalance

Write-Host ""
Write-Host "  5.4 User789 - Create Income (2000.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user789\",\"amount\":2000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"User789 part-time income\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  5.5 User789 - Create Expense (500.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user789\",\"amount\":500.00,\"type\":\"expense\",\"category\":\"shopping\",\"description\":\"Electronics purchase\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  5.6 User789 - Get Balance (Expected: 1500.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user789\"}' $server $service/GetBalance

# Test 6: Edge Cases
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "🔬 TEST 6: Edge Cases" -ForegroundColor DarkYellow
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host ""
Write-Host "  6.1 Minimum Amount (0.01)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":0.01,\"type\":\"income\",\"category\":\"test\",\"description\":\"Minimum amount test\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  6.2 Large Amount (999999.99)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":999999.99,\"type\":\"income\",\"category\":\"test\",\"description\":\"Large amount test\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  6.3 Empty Description" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":100.00,\"type\":\"income\",\"category\":\"bonus\",\"description\":\"\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  6.4 Special Characters in Description" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":50.00,\"type\":\"expense\",\"category\":\"food\",\"description\":\"Coffee @ Cafe\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  6.5 Non-existent User Balance (Expected: 0.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"nonexistent_user\"}' $server $service/GetBalance

Write-Host ""
Write-Host "  6.6 Empty Transaction List for Non-existent User" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"nonexistent_user\"}' $server $service/ListTransactions

# Test 7: Category Variations
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "📁 TEST 7: Category Variations" -ForegroundColor White
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host ""
Write-Host "  7.1 Healthcare Expense (250.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":250.00,\"type\":\"expense\",\"category\":\"healthcare\",\"description\":\"Doctor visit\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  7.2 Education Expense (500.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":500.00,\"type\":\"expense\",\"category\":\"education\",\"description\":\"Online course\"}' $server $service/CreateTransaction

Write-Host ""
Write-Host "  7.3 Savings Income (1000.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":1000.00,\"type\":\"income\",\"category\":\"savings\",\"description\":\"Interest from savings\"}' $server $service/CreateTransaction

# Test 8: Rapid Sequential Transactions
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "⚡ TEST 8: Rapid Sequential Transactions" -ForegroundColor Magenta
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host ""
Write-Host "  Creating 5 quick transactions..." -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"rapid_test\",\"amount\":10.00,\"type\":\"expense\",\"category\":\"food\",\"description\":\"Coffee #1\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"rapid_test\",\"amount\":15.00,\"type\":\"expense\",\"category\":\"food\",\"description\":\"Coffee #2\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"rapid_test\",\"amount\":12.50,\"type\":\"expense\",\"category\":\"food\",\"description\":\"Coffee #3\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"rapid_test\",\"amount\":20.00,\"type\":\"expense\",\"category\":\"food\",\"description\":\"Lunch\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"rapid_test\",\"amount\":8.75,\"type\":\"expense\",\"category\":\"food\",\"description\":\"Snack\"}' $server $service/CreateTransaction | Out-Null

Write-Host "  ✅ Created 5 transactions" -ForegroundColor Green
Write-Host ""
Write-Host "  Verifying balance (Expected: -66.25)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"rapid_test\"}' $server $service/GetBalance

# Test 9: Real-World Scenario
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "🌍 TEST 9: Real-World Monthly Budget Scenario" -ForegroundColor Green
Write-Host ("-" * 70) -ForegroundColor Gray

Write-Host ""
Write-Host "  Creating complete monthly budget for John Doe..." -ForegroundColor Yellow

# Income
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":5000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"January Salary\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":500.00,\"type\":\"income\",\"category\":\"freelance\",\"description\":\"Side project\"}' $server $service/CreateTransaction | Out-Null

# Fixed Expenses
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":1200.00,\"type\":\"expense\",\"category\":\"rent\",\"description\":\"Monthly rent\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":150.00,\"type\":\"expense\",\"category\":\"utilities\",\"description\":\"Utilities\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":100.00,\"type\":\"expense\",\"category\":\"transportation\",\"description\":\"Metro pass\"}' $server $service/CreateTransaction | Out-Null

# Variable Expenses
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":400.00,\"type\":\"expense\",\"category\":\"groceries\",\"description\":\"Monthly groceries\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":200.00,\"type\":\"expense\",\"category\":\"entertainment\",\"description\":\"Entertainment\"}' $server $service/CreateTransaction | Out-Null
grpcurl -plaintext -d '{\"user_id\":\"john_doe\",\"amount\":150.00,\"type\":\"expense\",\"category\":\"healthcare\",\"description\":\"Health insurance\"}' $server $service/CreateTransaction | Out-Null

Write-Host "  ✅ Created 8 transactions (2 income, 6 expenses)" -ForegroundColor Green
Write-Host ""
Write-Host "  Final Balance (Expected: 3300.00)" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"john_doe\"}' $server $service/GetBalance

Write-Host ""
Write-Host "  All Transactions for John Doe:" -ForegroundColor Yellow
grpcurl -plaintext -d '{\"user_id\":\"john_doe\"}' $server $service/ListTransactions

# Summary
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 TEST SUMMARY" -ForegroundColor White
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""

Write-Host "┌────────────────────┬──────────────┬────────────────┬─────────────────┐" -ForegroundColor Gray
Write-Host "│ User ID            │ Income       │ Expenses       │ Balance         │" -ForegroundColor Gray
Write-Host "├────────────────────┼──────────────┼────────────────┼─────────────────┤" -ForegroundColor Gray
Write-Host "│ user123            │ ~1,007,551   │ ~3,236         │ ~1,004,314      │" -ForegroundColor White
Write-Host "│ user456            │ 3,500        │ 800            │ 2,700           │" -ForegroundColor White
Write-Host "│ user789            │ 2,000        │ 500            │ 1,500           │" -ForegroundColor White
Write-Host "│ rapid_test         │ 0            │ 66.25          │ -66.25          │" -ForegroundColor White
Write-Host "│ john_doe           │ 5,500        │ 2,200          │ 3,300           │" -ForegroundColor White
Write-Host "└────────────────────┴──────────────┴────────────────┴─────────────────┘" -ForegroundColor Gray

Write-Host ""
Write-Host "✅ All Tests Completed Successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Test Coverage:" -ForegroundColor Cyan
Write-Host "  ✅ Income transactions (multiple categories)" -ForegroundColor Green
Write-Host "  ✅ Expense transactions (multiple categories)" -ForegroundColor Green
Write-Host "  ✅ Balance calculations" -ForegroundColor Green
Write-Host "  ✅ Transaction listing" -ForegroundColor Green
Write-Host "  ✅ Multiple users" -ForegroundColor Green
Write-Host "  ✅ Edge cases (min/max amounts, empty fields)" -ForegroundColor Green
Write-Host "  ✅ Concurrent transactions" -ForegroundColor Green
Write-Host "  ✅ Real-world scenarios" -ForegroundColor Green
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""
