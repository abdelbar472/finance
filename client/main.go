package main

import (
	"context"
	"log"
	"time"

	pb "finance-app/proto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func main() {
	conn, err := grpc.NewClient("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
	defer conn.Close()

	client := pb.NewFinanceServiceClient(conn)

	// Create a transaction
	tx, err := client.CreateTransaction(context.Background(), &pb.CreateTransactionRequest{
		UserId:      "user123",
		Amount:      100.50,
		Type:        "income",
		Category:    "salary",
		Description: "Monthly salary",
	})
	if err != nil {
		log.Fatalf("Error creating transaction: %v", err)
	}
	log.Printf("Created transaction: %v", tx)

	// Get balance
	time.Sleep(100 * time.Millisecond)
	balance, err := client.GetBalance(context.Background(), &pb.GetBalanceRequest{UserId: "user123"})
	if err != nil {
		log.Fatalf("Error getting balance: %v", err)
	}
	log.Printf("Balance: %.2f", balance.Balance)

	// List transactions
	list, err := client.ListTransactions(context.Background(), &pb.ListTransactionsRequest{UserId: "user123"})
	if err != nil {
		log.Fatalf("Error listing transactions: %v", err)
	}
	log.Printf("Transactions: %v", list.Transactions)
}
