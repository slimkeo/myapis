<?php
class DashboardController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $data = [];

        // Claims count
        $result = $this->conn->query("SELECT COUNT(*) as total FROM claims WHERE member_id = $member_id");
        $data['claims'] = $result->fetch_assoc()['total'];

        // Monthly Contribution
        $result = $this->conn->query("SELECT amount FROM statements WHERE memberid = $member_id AND type = 'contribution' ORDER BY id DESC LIMIT 1");
        $data['monthly_contribution'] = $result->num_rows > 0 ? $result->fetch_assoc()['amount'] : 150.00;

        // Beneficiaries count
        $result = $this->conn->query("SELECT COUNT(*) as total FROM beneficiaries WHERE member_id = $member_id");
        $data['beneficiaries'] = $result->fetch_assoc()['total'];

        // Policy Status (You can adjust logic)
        $data['policy_status'] = 'Active';
        $data['coverage_amount'] = 15000.00;

        json_response(true, $data);
    }
}