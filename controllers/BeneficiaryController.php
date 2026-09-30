<?php
class BeneficiaryController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $member_id=1100001;
        // Table columns: memberid, nameof (not member_id / full_name); no maturity_status
        $stmt = $this->conn->prepare("
            SELECT
                id,
                fullname,
                gender,
                dob,
                status,
                is_spouse,
                submission_date,
                status_date
            FROM beneficiaries
            WHERE memberid = ?
            ORDER BY submission_date
        ");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $beneficiaries = [];
        while ($row = $result->fetch_assoc()) {
            $row['is_spouse'] = (int)($row['is_spouse'] ?? 0) === 1;
            $beneficiaries[] = $row;
        }

        json_response(true, $beneficiaries);
    }
}
