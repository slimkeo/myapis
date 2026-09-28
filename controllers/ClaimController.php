<?php
class ClaimController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $stmt = $this->conn->prepare("
            SELECT
                c.id,
                c.claim_type,
                COALESCE(b.nameof, 'N/A') AS beneficiary,
                c.amount,
                c.claim_date,
                c.status,
                c.approved_date,
                c.payment_date
            FROM claims c
            LEFT JOIN beneficiaries b
                ON b.id = c.beneficiary_id AND b.memberid = c.member_id
            WHERE c.member_id = ?
            ORDER BY c.claim_date DESC
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
