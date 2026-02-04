package main

import (
	"context"
	"log"
	"net"
	"sync"
	"time"

	pb "finance-app/proto"

	"github.com/google/uuid"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct {
	pb.UnimplementedFinanceServiceServer
	transactions map[string]*pb.Transaction
	mu           sync.RWMutex
}

func (s *server) CreateTransaction(ctx context.Context, req *pb.CreateTransactionRequest) (*pb.Transaction, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	transaction := &pb.Transaction{
		Id:          uuid.New().String(),
		UserId:      req.UserId,
		Amount:      req.Amount,
		Type:        req.Type,
		Category:    req.Category,
		Description: req.Description,
		Timestamp:   time.Now().Unix(),
	}

	s.transactions[transaction.Id] = transaction
	log.Printf("Created transaction: %s for user %s, amount: %.2f", transaction.Id, transaction.UserId, transaction.Amount)
	return transaction, nil
}

func (s *server) GetTransaction(ctx context.Context, req *pb.GetTransactionRequest) (*pb.Transaction, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if tx, ok := s.transactions[req.Id]; ok {
		return tx, nil
	}
	return nil, nil
}

func (s *server) ListTransactions(ctx context.Context, req *pb.ListTransactionsRequest) (*pb.ListTransactionsResponse, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var transactions []*pb.Transaction
	for _, tx := range s.transactions {
		if tx.UserId == req.UserId {
			transactions = append(transactions, tx)
		}
	}

	return &pb.ListTransactionsResponse{Transactions: transactions}, nil
}

func (s *server) GetBalance(ctx context.Context, req *pb.GetBalanceRequest) (*pb.BalanceResponse, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var balance float64
	for _, tx := range s.transactions {
		if tx.UserId == req.UserId {
			if tx.Type == "income" {
				balance += tx.Amount
			} else {
				balance -= tx.Amount
			}
		}
	}

	return &pb.BalanceResponse{Balance: balance}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterFinanceServiceServer(s, &server{
		transactions: make(map[string]*pb.Transaction),
	})

	reflection.Register(s)

	log.Println("Server listening on :50051 with reflection enabled")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
