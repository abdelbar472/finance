// server/main.go
package main

import (
	"context"
	"log"
	"net"
	"sync"

	pb "finance-app/proto"

	"github.com/google/uuid"
	"google.golang.org/grpc"
)

type server struct {
	pb.UnimplementedFinanceServiceServer
	mu           sync.Mutex
	transactions []*pb.Transaction
	balance      float64
}

func (s *server) AddTransaction(ctx context.Context, req *pb.AddTransactionRequest) (*pb.TransactionResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	amount := req.Amount
	if req.Type == "out" {
		amount = -amount
	}

	tx := &pb.Transaction{
		Id:     uuid.New().String(),
		Name:   req.Name,
		Amount: amount,
		Type:   req.Type,
	}

	s.transactions = append(s.transactions, tx)
	s.balance += amount

	return &pb.TransactionResponse{Transaction: tx}, nil
}

func (s *server) GetBalance(ctx context.Context, req *pb.Empty) (*pb.BalanceResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	return &pb.BalanceResponse{Balance: s.balance}, nil
}

func (s *server) ListTransactions(ctx context.Context, req *pb.Empty) (*pb.TransactionsResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	return &pb.TransactionsResponse{Transactions: s.transactions}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterFinanceServiceServer(s, &server{})

	log.Println("Server running on :50051")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
