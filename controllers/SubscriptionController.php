<?php
class SubscriptionController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $stmt = $this->conn->prepare("
            SELECT id, date, description, amount, type, status, source 
            FROM statements 
            WHERE memberid = ? 
            ORDER BY date DESC
        ");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $statements = [];
        while ($row = $result->fetch_assoc()) {
            $statements[] = $row;
        }

        json_response(true, $statements);
    }
}