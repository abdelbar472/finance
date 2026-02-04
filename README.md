# Finance gRPC Application

A simple finance management application built with gRPC and Go that tracks income and expenses, calculates balances, and manages transactions.

## 📋 Features

- ✅ Create income and expense transactions
- ✅ Track multiple users
- ✅ Get real-time balance calculations
- ✅ List all transactions per user
- ✅ Retrieve individual transactions by ID
- ✅ gRPC server with reflection enabled
- ✅ Concurrent-safe with mutex locks
- ✅ In-memory storage

## 🏗️ Architecture

```
finance/
├── proto/               # Protocol Buffer definitions
│   ├── finance.proto
│   ├── finance.pb.go
│   └── finance_grpc.pb.go
├── server/             # gRPC server implementation
│   └── main.go
├── client/             # gRPC client implementation
│   └── main.go
├── tests/              # Test files
│   ├── postman_tests.md
│   ├── run_all_tests.ps1
│   └── Finance_gRPC_Complete.postman_collection.json
├── go.mod
├── go.sum
└── README.md
```

## 🚀 Quick Start

### Prerequisites

- Go 1.20 or higher
- Protocol Buffer compiler (protoc)
- grpcurl (optional, for testing)

### Installation

```powershell
# 1. Clone the repository
git clone <your-repo-url>
cd finance

# 2. Install dependencies
go mod download

# 3. Generate Protocol Buffer code (if needed)
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/finance.proto
```

### Running the Application

**Start the gRPC Server:**
```powershell
go run server/main.go
```
Output:
```
2024/02/04 18:30:00 Server listening on :50051 with reflection enabled
```

**Run the Client (in a new terminal):**
```powershell
go run client/main.go
```

## 📡 API Endpoints

### Service Definition

```protobuf
service FinanceService {
  rpc CreateTransaction(CreateTransactionRequest) returns (Transaction);
  rpc GetTransaction(GetTransactionRequest) returns (Transaction);
  rpc ListTransactions(ListTransactionsRequest) returns (ListTransactionsResponse);
  rpc GetBalance(GetBalanceRequest) returns (BalanceResponse);
}
```

### 1. CreateTransaction

Creates a new income or expense transaction.

**Endpoint:** `finance.FinanceService/CreateTransaction`

**Request:**
```json
{
  "user_id": "user123",
  "amount": 1500.00,
  "type": "income",
  "category": "salary",
  "description": "Monthly salary"
}
```

**Response:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user123",
  "amount": 1500.00,
  "type": "income",
  "category": "salary",
  "description": "Monthly salary",
  "timestamp": 1707065400
}
```

**Parameters:**
- `user_id` (string): User identifier
- `amount` (double): Transaction amount
- `type` (string): "income" or "expense"
- `category` (string): Transaction category
- `description` (string): Transaction description

---

### 2. GetTransaction

Retrieves a specific transaction by ID.

**Endpoint:** `finance.FinanceService/GetTransaction`

**Request:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user123",
  "amount": 1500.00,
  "type": "income",
  "category": "salary",
  "description": "Monthly salary",
  "timestamp": 1707065400
}
```

**Parameters:**
- `id` (string): Transaction ID (UUID)

---

### 3. ListTransactions

Lists all transactions for a specific user.

**Endpoint:** `finance.FinanceService/ListTransactions`

**Request:**
```json
{
  "user_id": "user123"
}
```

**Response:**
```json
{
  "transactions": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "user_id": "user123",
      "amount": 1500.00,
      "type": "income",
      "category": "salary",
      "description": "Monthly salary",
      "timestamp": 1707065400
    },
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "user_id": "user123",
      "amount": 500.00,
      "type": "expense",
      "category": "rent",
      "description": "Monthly rent",
      "timestamp": 1707065500
    }
  ]
}
```

**Parameters:**
- `user_id` (string): User identifier

---

### 4. GetBalance

Calculates the current balance for a user (total income - total expenses).

**Endpoint:** `finance.FinanceService/GetBalance`

**Request:**
```json
{
  "user_id": "user123"
}
```

**Response:**
```json
{
  "balance": 1000.00
}
```

**Parameters:**
- `user_id` (string): User identifier

---

## 🧪 Testing

### Option 1: Postman (Recommended)

1. **Open Postman**
2. **Create new gRPC request**
3. **Configure:**
   - Server URL: `localhost:50051`
   - Use TLS: ❌ **UNCHECKED**
   - Server Reflection: ✅ **CHECKED**

4. **Import collection:**
   ```
   tests/Finance_gRPC_Complete.postman_collection.json
   ```

5. **Run tests** - See [tests/postman_tests.md](tests/postman_tests.md) for detailed guide

### Option 2: grpcurl

Install grpcurl:
```powershell
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```

**Test Commands:**

```powershell
# List all services
grpcurl -plaintext localhost:50051 list

# Create income transaction
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":1500.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"Monthly salary\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Create expense transaction
grpcurl -plaintext -d '{\"user_id\":\"user123\",\"amount\":500.00,\"type\":\"expense\",\"category\":\"rent\",\"description\":\"Monthly rent\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Get balance
grpcurl -plaintext -d '{\"user_id\":\"user123\"}' localhost:50051 finance.FinanceService/GetBalance

# List all transactions
grpcurl -plaintext -d '{\"user_id\":\"user123\"}' localhost:50051 finance.FinanceService/ListTransactions

# Get specific transaction (replace with actual ID)
grpcurl -plaintext -d '{\"id\":\"TRANSACTION_ID_HERE\"}' localhost:50051 finance.FinanceService/GetTransaction
```

### Option 3: Automated PowerShell Script

Run comprehensive automated tests:
```powershell
cd tests
.\run_all_tests.ps1
```

This script tests:
- ✅ All 4 endpoints
- ✅ Multiple users
- ✅ Edge cases
- ✅ Category variations
- ✅ Rapid sequential transactions
- ✅ Real-world scenarios

### Option 4: Go Client

Run the included test client:
```powershell
go run client/main.go
```

## 📝 Example Usage Scenarios

### Scenario 1: Personal Monthly Budget

```powershell
# Add January salary
grpcurl -plaintext -d '{\"user_id\":\"john\",\"amount\":5000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"January salary\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Add rent
grpcurl -plaintext -d '{\"user_id\":\"john\",\"amount\":1500.00,\"type\":\"expense\",\"category\":\"rent\",\"description\":\"Monthly rent\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Add groceries
grpcurl -plaintext -d '{\"user_id\":\"john\",\"amount\":450.00,\"type\":\"expense\",\"category\":\"groceries\",\"description\":\"Weekly shopping\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Add utilities
grpcurl -plaintext -d '{\"user_id\":\"john\",\"amount\":125.00,\"type\":\"expense\",\"category\":\"utilities\",\"description\":\"Electric bill\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Check balance
grpcurl -plaintext -d '{\"user_id\":\"john\"}' localhost:50051 finance.FinanceService/GetBalance
# Expected: 2925.00
```

### Scenario 2: Freelancer Income Tracking

```powershell
# Regular salary
grpcurl -plaintext -d '{\"user_id\":\"alice\",\"amount\":3000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"Part-time salary\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Freelance project 1
grpcurl -plaintext -d '{\"user_id\":\"alice\",\"amount\":1200.00,\"type\":\"income\",\"category\":\"freelance\",\"description\":\"Website project\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Freelance project 2
grpcurl -plaintext -d '{\"user_id\":\"alice\",\"amount\":800.00,\"type\":\"income\",\"category\":\"freelance\",\"description\":\"Logo design\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Check total income
grpcurl -plaintext -d '{\"user_id\":\"alice\"}' localhost:50051 finance.FinanceService/GetBalance
# Expected: 5000.00
```

### Scenario 3: Multiple Users

```powershell
# User 1
grpcurl -plaintext -d '{\"user_id\":\"user1\",\"amount\":3000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"Salary\"}' localhost:50051 finance.FinanceService/CreateTransaction

# User 2
grpcurl -plaintext -d '{\"user_id\":\"user2\",\"amount\":4000.00,\"type\":\"income\",\"category\":\"salary\",\"description\":\"Salary\"}' localhost:50051 finance.FinanceService/CreateTransaction

# Check balances separately
grpcurl -plaintext -d '{\"user_id\":\"user1\"}' localhost:50051 finance.FinanceService/GetBalance
grpcurl -plaintext -d '{\"user_id\":\"user2\"}' localhost:50051 finance.FinanceService/GetBalance
```

## 📂 Transaction Categories

### Income Categories
- `salary` - Regular employment income
- `freelance` - Freelance work
- `investment` - Investment returns, dividends
- `bonus` - Bonuses and gifts
- `savings` - Interest from savings
- `other` - Other income sources

### Expense Categories
- `rent` - Housing rent/mortgage
- `groceries` - Food and groceries
- `utilities` - Electricity, water, internet
- `transportation` - Commute, gas, vehicle
- `entertainment` - Movies, dining, hobbies
- `healthcare` - Medical expenses
- `education` - Courses, books
- `shopping` - General shopping
- `food` - Restaurants, cafes
- `other` - Other expenses

## 🔧 Configuration

### Server Settings
- **Port:** 50051
- **Protocol:** gRPC (plaintext, no TLS)
- **Reflection:** Enabled
- **Storage:** In-memory (map)

### Client Settings
- **Server Address:** localhost:50051
- **Transport:** Insecure credentials (no TLS)

## 🛠️ Development

### Adding New Features

1. **Update Protocol Buffer:**
   ```protobuf
   // Add to proto/finance.proto
   rpc NewMethod(NewRequest) returns (NewResponse);
   
   message NewRequest {
     string field = 1;
   }
   
   message NewResponse {
     string result = 1;
   }
   ```

2. **Regenerate code:**
   ```powershell
   protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/finance.proto
   ```

3. **Implement in server:**
   ```go
   func (s *server) NewMethod(ctx context.Context, req *pb.NewRequest) (*pb.NewResponse, error) {
       // Implementation
       return &pb.NewResponse{Result: "success"}, nil
   }
   ```

4. **Test the new endpoint**

## 🐛 Troubleshooting

### Issue 1: "Connection refused"
**Error:** Cannot connect to server
**Solution:** Make sure the server is running:
```powershell
go run server/main.go
```

### Issue 2: "package finance-app/proto is not in std"
**Error:** Import errors
**Solution:** Run go mod tidy:
```powershell
go mod tidy
```

### Issue 3: "Could not make proto path relative"
**Error:** protoc cannot find proto file
**Solution:** Ensure you're in the project root:
```powershell
cd D:\codes\finance
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative proto/finance.proto
```

### Issue 4: Postman SSL/TLS Error
**Error:** `Error: 14915776:error:100000f7:SSL routines:OPENSSL_internal:WRONG_VERSION_NUMBER`
**Solution:** **Uncheck "Use TLS"** in Postman gRPC settings

### Issue 5: "grpcurl: command not found"
**Error:** grpcurl not installed
**Solution:** Install grpcurl:
```powershell
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```
Ensure `%GOPATH%\bin` is in your PATH.

### Issue 6: Server reflection not working
**Error:** "Server does not support reflection"
**Solution:** Verify reflection is registered in server/main.go:
```go
reflection.Register(s)
```

## ⚡ Performance Considerations

- **In-memory storage:** Data is stored in memory and will be lost on server restart
- **Concurrency:** Uses RWMutex locks for thread-safe operations
- **No persistence:** For production, integrate a database (PostgreSQL, MongoDB, etc.)
- **Scalability:** Current implementation suitable for development/testing

## 🚀 Future Enhancements

- [ ] Database persistence (PostgreSQL/MongoDB)
- [ ] User authentication and authorization (JWT)
- [ ] Transaction filtering by date range
- [ ] Transaction update and delete operations
- [ ] Category management CRUD
- [ ] Budget tracking and alerts
- [ ] Expense reports and analytics
- [ ] REST API gateway (gRPC-Gateway)
- [ ] Docker containerization
- [ ] Unit and integration tests
- [ ] TLS/SSL support for production
- [ ] Logging and monitoring (Prometheus, Grafana)
- [ ] CI/CD pipeline
- [ ] API rate limiting
- [ ] Data export (CSV, PDF)

## 📦 Dependencies

```
google.golang.org/grpc v1.78.0
google.golang.org/protobuf v1.36.11
github.com/google/uuid v1.6.0
golang.org/x/net v0.47.0
golang.org/x/sys v0.38.0
golang.org/x/text v0.31.0
google.golang.org/genproto/googleapis/rpc v0.0.0-20251029180050-ab9386a59fda
```

## 📊 Test Coverage

Our test suite includes:
- ✅ **28+ test cases** covering all endpoints
- ✅ **Income transactions** - Multiple categories and amounts
- ✅ **Expense transactions** - Various expense types
- ✅ **Balance calculations** - Accurate income-expense tracking
- ✅ **Transaction listing** - User-specific queries
- ✅ **Multiple users** - Isolation and concurrency
- ✅ **Edge cases** - Min/max amounts, empty fields, special characters
- ✅ **Real-world scenarios** - Monthly budgets, freelance tracking

## 📄 License

MIT License

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Contact

- **Project Repository:** [https://github.com/yourusername/finance](https://github.com/yourusername/finance)
- **Issues:** [https://github.com/yourusername/finance/issues](https://github.com/yourusername/finance/issues)

## 🙏 Acknowledgments

- [gRPC](https://grpc.io/) - High-performance RPC framework
- [Protocol Buffers](https://developers.google.com/protocol-buffers) - Data serialization
- [Go](https://golang.org/) - Programming language
- [UUID](https://github.com/google/uuid) - UUID generation library

---

**Happy Coding! 💰📊**
