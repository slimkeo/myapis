<?php
class ClaimController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $stmt = $this->conn->prepare("
            SELECT id, beneficiary_id, amount, claim_date, status, approved_date, payment_date 
            FROM claims 
            WHERE member_id = ? 
            ORDER BY claim_date DESC
        ");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $claims = [];
        while ($row = $result->fetch_assoc()) {
            $claims[] = $row;
        }

        json_response(true, $claims);
    }
}
