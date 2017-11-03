# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171103001620) do

  create_table "items", force: :cascade do |t|
    t.string   "client_ssn"
    t.string   "client_name"
    t.string   "case_type"
    t.string   "status"
    t.datetime "date_opened"
    t.datetime "date_closed"
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
    t.string   "case_id"
    t.string   "income_issues_wages"
    t.string   "income_issues_interest_dividends_schedule_b"
    t.string   "income_issues_business_income_schedule_c"
    t.string   "income_issues_capital_gain_loss_schedule_d"
    t.string   "income_issues_ira_pension"
    t.string   "income_issues_social_security_benefits"
    t.string   "income_issues_alimony"
    t.string   "income_issues_rental_royalty_partnership_s_corp_schedule_e"
    t.string   "income_issues_farming_income_schedule_f"
    t.string   "income_issues_unemployment"
    t.string   "income_issues_gambling_winnings"
    t.string   "income_issues_cancellation_of_debt"
    t.string   "income_issues_settlement_proceeds"
    t.string   "income_issues_other_income_issues"
    t.string   "deduction_issues_alimony"
    t.string   "deduction_issues_education_expenses_including_student_loan_interest"
    t.string   "deduction_issues_moving_expenses"
    t.string   "deduction_issues_ira_deduction"
    t.string   "deduction_issues_medical_and_dental_expenses"
    t.string   "deduction_issues_state_and_local_taxes"
    t.string   "deduction_issues_home_mortgage_interest"
    t.string   "deduction_issues_other_interest_expenses"
    t.string   "deduction_issues_charitable_contributions"
    t.string   "deduction_issues_casualty_and_theft_losses"
    t.string   "deduction_issues_unreimbursed_employee_business_expenses"
    t.string   "deduction_issues_other_itemized_deductions"
    t.string   "deduction_issues_business_expenses_schedule_c"
    t.string   "credit_issues_child_and_dependent_care_credit"
    t.string   "credit_issues_education_credits"
    t.string   "credit_issues_child_tax_credit_additional_child_tax_credit"
    t.string   "credit_issues_earned_income_tax_credit"
    t.string   "credit_issues_first_time_homebuyer_credit"
    t.string   "credit_issues_premium_tax_credit"
    t.string   "credit_issues_other_credits"
    t.string   "status_issues_ssn_tin"
    t.string   "status_issues_itin"
    t.string   "status_issues_filing_status"
    t.string   "status_issues_personal_dependency_exemptions"
    t.string   "status_issues_injured_spouse"
    t.string   "status_issues_innocent_spouse"
    t.string   "status_issues_employment_related_identity_theft"
    t.string   "status_issues_refund_related_identity_theft"
    t.string   "status_issues_nonfiler"
    t.string   "status_issues_worker_classification"
    t.string   "tax_issues_self_employment_tax"
    t.string   "tax_issues_suspected_return_preparer_fraud"
    t.string   "tax_issues_estimated_tax_payments"
    t.string   "tax_issues_withholdings"
    t.string   "tax_issues_refund"
    t.string   "tax_issues_assessment_statute_of_limitations"
    t.string   "tax_issues_collection_statute_of_limitations"
    t.string   "tax_issues_refund_statute_of_limitations"
    t.string   "penalty_issues_trust_fund_recovery_penalty"
    t.string   "penalty_issues_other_civil_penalties"
    t.string   "penalty_issues_additional_tax_on_distributions_from_qualified_retirement_plans"
    t.string   "penalty_issues_individual_shared_responsibility_payment"
    t.string   "collection_issues_payments"
    t.string   "collection_issues_installment_payment_agreement_ipa"
    t.string   "collection_issues_offer_in_compromise_oic"
    t.string   "collection_issues_currently_not_collectible_cnc"
    t.string   "collection_issues_liens"
    t.string   "collection_issues_levies_including_federal_payment_levy_program"
    t.string   "name_of_clinic"
    t.string   "grant_year"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

end
