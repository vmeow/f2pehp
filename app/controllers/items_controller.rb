class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # GET /items
  # GET /items.json
  def index
    sort_by = params[:sort_by] || session[:sort_by]
    search_term = params[:search] || session[:search]
    if params[:sort_by] != session[:sort_by] || params[:search] != session[:search]
      session[:sort_by] = sort_by
      session[:search] = search_term
      redirect_to(items_path(sort_by: sort_by, search: search_term)) && return
    end

    # case sort_by
    #   when 'client_ssn'
    #     ordering = 'client_ssn'
    #   when 'client_name'
    #     ordering = 'client_name'
    # end

    ordering = sort_by

    if !search_term.nil?
      @items = Item.where('client_name like ? OR client_ssn like ? OR case_id like ?', "%#{search_term}%", "%#{search_term}%", "%#{search_term}%").order(ordering)
      @old_items = Item.where('(client_name like ? OR client_ssn like ? OR case_id like ?) AND date_opened < ?', "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", 90.days.ago)
    else
      @items = Item.order(ordering)
      @old_items = Item.where('date_opened < ?', 90.days.ago)
    end

    @items_alert_message = ''
    unless @old_items.empty?
      @items_alert_message = 'Case has been open for 90 days: '
      @old_items.each do |item|
        @items_alert_message += item[:client_ssn] + ', '
      end
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show;
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find params[:id]
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.create!(item_params)
    tempCaseIdBase = format('%04d', @item[:date_opened].year) + format('%02d', @item[:date_opened].month) + format('%02d', @item[:date_opened].day)
    idNum = if Setting.get_all.key?(tempCaseIdBase)
              Setting[tempCaseIdBase] + 1
            else
              0
            end
    Setting[tempCaseIdBase] = idNum

    tempCaseId = tempCaseIdBase + format('%03d', idNum)
    @item.update_attributes(case_id: tempCaseId)
    flash[:notice] = 'Item was successfully created.' + @item[:date_opened].year.to_s
    redirect_to items_path
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html {redirect_to items_path, notice: 'Item was successfully updated.'}
        format.json {render :show, status: :ok, location: @item}
      else
        format.html {render :edit}
        format.json {render json: @item.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html {redirect_to items_url, notice: 'Item was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name_of_clinic,
      :grant_year,
      :income_issues_wages, 
      :income_issues_interest_dividends_schedule_b, 
      :income_issues_business_income_schedule_c, 
      :income_issues_capital_gain_loss_schedule_d, 
      :income_issues_ira_pension, 
      :income_issues_social_security_benefits, 
      :income_issues_alimony, 
      :income_issues_rental_royalty_partnership_s_corp, 
      :income_issues_farming_income_schedule_f, 
      :income_issues_unemployment, 
      :income_issues_gambling_winnings, 
      :income_issues_cancellation_of_debt, 
      :income_issues_settlement_proceeds, 
      :income_issues_other_income_issues, 
      :deduction_issues_alimony, 
      :deduction_issues_education_expenses_including_st, 
      :deduction_issues_moving_expenses, 
      :deduction_issues_ira_deduction, 
      :deduction_issues_medical_and_dental_expenses, 
      :deduction_issues_state_and_local_taxes, 
      :deduction_issues_home_mortgage_interest, 
      :deduction_issues_other_interest_expenses, 
      :deduction_issues_charitable_contributions, 
      :deduction_issues_casualty_and_theft_losses, 
      :deduction_issues_unreimbursed_employee_business, 
      :deduction_issues_other_itemized_deductions, 
      :deduction_issues_business_expenses_schedule_c, 
      :credit_issues_child_and_dependent_care_credit, 
      :credit_issues_education_credits, 
      :credit_issues_child_tax_credit_additional_child, 
      :credit_issues_earned_income_tax_credit, 
      :credit_issues_first_time_homebuyer_credit, 
      :credit_issues_premium_tax_credit, 
      :credit_issues_other_credits, 
      :status_issues_ssn_tin, 
      :status_issues_itin, 
      :status_issues_filing_status, 
      :status_issues_personal_dependency_exemptions, 
      :status_issues_injured_spouse, 
      :status_issues_innocent_spouse, 
      :status_issues_employment_related_identity_theft, 
      :status_issues_refund_related_identity_theft, 
      :status_issues_nonfiler, 
      :status_issues_worker_classification, 
      :tax_issues_self_employment_tax, 
      :tax_issues_suspected_return_preparer_fraud, 
      :tax_issues_estimated_tax_payments, 
      :tax_issues_withholdings, 
      :tax_issues_refund, 
      :tax_issues_assessment_statute_of_limitations, 
      :tax_issues_collection_statute_of_limitations, 
      :tax_issues_refund_statute_of_limitations, 
      :penalty_issues_trust_fund_recovery_penalty, 
      :penalty_issues_other_civil_penalties, 
      :penalty_issues_additional_tax_on_distributions_f, 
      :penalty_issues_individual_shared_responsibility, 
      :collection_issues_payments, 
      :collection_issues_installment_payment_agreement, 
      :collection_issues_offer_in_compromise_oic, 
      :collection_issues_currently_not_collectible_cnc, 
      :collection_issues_liens, 
      :collection_issues_levies_including_federal_payme, 
      :inventory_beginning_case_inventory, 
      :inventory_new_cases_opened_during_the_reporting, 
      :inventory_total_number_of_cases_worked_during_th, 
      :inventory_cases_closed_during_the_reporting_peri, 
      :inventory_ending_case_inventory, 
      :accounts_return_processing, 
      :accounts_penalty_abatement, 
      :accounts_injured_spouse, 
      :accounts_backup_withholding, 
      :exams_correspondence_exam, 
      :exams_office_or_field_exam, 
      :exams_automated_underreporter, 
      :exams_automated_substitute_for_return, 
      :exams_audit_reconsideration, 
      :collection_automated_collection_system, 
      :collection_field_collection, 
      :collection_offer_in_compromise, 
      :collection_lien_unit, 
      :collection_bankruptcy, 
      :appeals_exam_appeals, 
      :appeals_collection_due_process, 
      :appeals_collection_appeals_process, 
      :appeals_oic_appeals, 
      :appeals_penalty_abatement_appeals, 
      :appeals_other_appeals, 
      :litigation_us_tax_court, 
      :litigation_other_federal_courts, 
      :miscellaneous_identity_protection_specialized_un, 
      :miscellaneous_innocent_spouse_unit, 
      :miscellaneous_ss_8_unit, 
      :miscellaneous_itin_unit, 
      :miscellaneous_trust_fund_recovery_penalty, 
      :total, 
      :additional_the_amount_in_controversy_exceeds_500, 
      :additional_the_taxpayers_income_exceeds_250_of, 
      :additional_matters_worked_in_more_than_on_irs_fu, 
      :additional_more_than_one_tax_year, 
      :additional_representation_of_esl_taxpayers, 
      :additional_joint_representation_of_taxpayers, 
      :additional_representation_by_volunteers, 
      :additional_state_tax_matters, 
      :tax_court_does_the_clinic_participate_in_the_us, 
      :tax_court_list_the_places_of_trial_location_serv, 
      :tax_court_number_of_us_tax_court_cases_worked_du, 
      :tax_court_number_of_us_tax_court_cases_worked_du, 
      :tax_court_number_of_informal_consultations_in_th, 
      :closed_case_a_number_of_cases_in_which_the_taxpa, 
      :closed_case_b_number_of_cases_in_which_the_taxpa, 
      :closed_case_c_total_amount_of_dollars_refunded_i, 
      :closed_case_d_total_decrease_in_corrected_tax_li)
  end
end
