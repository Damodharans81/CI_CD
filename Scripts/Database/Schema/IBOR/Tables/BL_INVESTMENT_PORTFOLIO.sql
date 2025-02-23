CREATE OR ALTER TABLE IBOR.BL_INVESTMENT_PORTFOLIO (
    ALADDIN_PORTFOLIO_ID NUMBER(38, 0) NOT NULL,
    ALADDIN_PORTFOLIO_CUSIP VARCHAR(9),
    PORTFOLIO_CODE VARCHAR(10),
    CUSTODIAN_PORTFOLIO_NAME VARCHAR(10),
    HSBC_PORTFOLIO_CODE VARCHAR(60),
    INVESTMENT_PORTFOLIO_ID NUMBER(38, 0) NOT NULL,
    PORTFOLIO_BASE_CURRENCY VARCHAR(3) NOT NULL,
    PM_LOGIN VARCHAR(8),
    PM_FIRST_NAME VARCHAR(25),
    PM_LAST_NAME VARCHAR(25),
    PORTFOLIO_GROUP_NAME VARCHAR(50),
    PORTFOLIO_LONG_NAME VARCHAR(75),
    INVESTMENT_VEHICLE_NAME VARCHAR(255),
    PORTFOLIO_SHORT_NAME VARCHAR(10),
    PORTFOLIO_STATUS VARCHAR(1),
    PORTFOLIO_TERMINATION_DATE TIMESTAMP_NTZ(9),
    BENCHMARK_TICKER_LATEST VARCHAR(10),
    STATESTREET_PORTFOLIO_CODE VARCHAR(60),
    CUSTODIAN_NAME VARCHAR(10),
    MANAGEMENT_COMPANY_NAME VARCHAR(255),
    MANAGEMENT_COMPANY_ADDRESS VARCHAR(255),
    ALADDIN_PORTFOLIO_LEI VARCHAR(60),
    PRODUCT_PORTFOLIO_LEI VARCHAR(20),
    LEGAL_PORTFOLIO_TYPE VARCHAR(255),
    LEGAL_PORTFOLIO_TYPE_DESCRIPTION VARCHAR(255),
    DISTRIBUTION_PORTFOLIO_TYPE VARCHAR(255),
    INVESTMENT_DESK_NAME VARCHAR(255),
    IFPR_K_FACTOR VARCHAR(255),
    UMBRELLA_NAME VARCHAR(255),
    PORTFOLIO_TYPE VARCHAR(25),
    REPORTING_CURRENCY VARCHAR(3),
    SFDR_CATEGORISATION VARCHAR(1000),
    INVESTMENT_ADVISOR VARCHAR(255),
    ADC_UPDATE_DATE TIMESTAMP_NTZ(9) NOT  NULL
);