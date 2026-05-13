<?php
class BeneficiaryController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $stmt = $this->conn->prepare("
            SELECT id, full_name, gender, dob, status, maturity_status 
            FROM beneficiaries 
            WHERE member_id = ? 
            ORDER BY full_name
        ");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $beneficiaries = [];
        while ($row = $result->fetch_assoc()) {
            $beneficiaries[] = $row;
        }

        json_response(true, $beneficiaries);
    }
}