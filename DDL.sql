--1: Agent (Master)
CREATE TABLE Agent (
    agent_id    INT AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    start_date  DATE NOT NULL,
    PRIMARY KEY (agent_id)
);

-- 2: Agent_Monthly_Performance (ตารางหลักของ validation tracking)
CREATE TABLE Agent_Monthly_Performance (
    performance_id     BIGINT AUTO_INCREMENT,
    agent_id           INT NOT NULL,
    performance_month  DATE NOT NULL,
    total_premium      DECIMAL(12,2) NOT NULL,
    policy_count       INT NOT NULL,
    validation_result  VARCHAR(10) NOT NULL,
    consecutive_count  INT NOT NULL,
    PRIMARY KEY (performance_id),
    FOREIGN KEY (agent_id) REFERENCES Agent(agent_id),
    UNIQUE (agent_id, performance_month),
    CHECK (total_premium >= 0),
    CHECK (policy_count >= 0),
    CHECK (validation_result IN ('PASS', 'FAIL')),
    CHECK (consecutive_count >= 1),
    -- Business rule: PASS = total_premium > 15,000 AND policy_count > 5
    CHECK (
        (validation_result = 'PASS' AND total_premium > 15000 AND policy_count > 5)
        OR
        (validation_result = 'FAIL' AND (total_premium <= 15000 OR policy_count <= 5))
    )
);

--  3: Agent_Contract_History (ประวัติการเปลี่ยนสัญญา)
CREATE TABLE Agent_Contract_History (
    contract_history_id  BIGINT AUTO_INCREMENT,
    agent_id             INT NOT NULL,
    contract_type        VARCHAR(20) NOT NULL,
    effective_date       DATE NOT NULL,
    PRIMARY KEY (contract_history_id),
    FOREIGN KEY (agent_id) REFERENCES Agent(agent_id),
    CHECK (contract_type IN ('SALARY_BASED', 'COMMISSION_BASED'))
);