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
      :client_name,
      :client_ssn,
      :date_opened,
      :date_closed,
      :income_issues_1_wages, 
      :income_issues_2_interest_divid, 
      :income_issues_3_business_incom, 
      :income_issues_4_capital_gain_o, 
      :income_issues_5_ira_pension, 
      :income_issues_6_social_securit, 
      :income_issues_7_alimony, 
      :income_issues_8_rental_royalty, 
      :income_issues_9_farming_income, 
      :income_issues_10_unemployment, 
      :income_issues_11_gambling_winn, 
      :income_issues_12_cancellation, 
      :income_issues_13_settlement_pr, 
      :income_issues_14_other, 
      :deduction_issues_15_alimony, 
      :deduction_issues_16_education, 
      :deduction_issues_17_moving_exp, 
      :deduction_issues_18_ira_deduct, 
      :deduction_issues_19_medical_an, 
      :deduction_issues_20_state_and, 
      :deduction_issues_21_home_mortg, 
      :deduction_issues_22_other_inte, 
      :deduction_issues_23_charitable, 
      :deduction_issues_24_casualty_a, 
      :deduction_issues_25_unreimburs, 
      :deduction_issues_26_other_item, 
      :deduction_issues_27_business_e, 
      :credit_issues_28_child_and_dep, 
      :credit_issues_29_education_cre, 
      :credit_issues_30_child_tax_cre, 
      :credit_issues_31_earned_income, 
      :credit_issues_32_first_time_ho, 
      :credit_issues_33_premium_tax_c, 
      :credit_issues_34_other_credits, 
      :status_issues_35_ssn_tin, 
      :status_issues_36_itin, 
      :status_issues_37_filing_status, 
      :status_issues_38_personal_depe, 
      :status_issues_39_injured_spous, 
      :status_issues_40_innocent_spou, 
      :status_issues_41_employment_re, 
      :status_issues_42_refund_relate, 
      :status_issues_43_nonfiler, 
      :status_issues_44_worker_classi, 
      :tax_issues_45_self_employment, 
      :tax_issues_46_suspected_return, 
      :tax_issues_47_estimated_tax_pa, 
      :tax_issues_48_withholdings, 
      :tax_issues_49_refund, 
      :tax_issues_50_assessment_statu, 
      :tax_issues_51_collection_statu, 
      :tax_issues_52_refund_statute_o, 
      :penalty_issues_53_trust_fund_r, 
      :penalty_issues_54_other_civil, 
      :penalty_issues_55_additional_t, 
      :penalty_issues_56_individual_s, 
      :collection_issues_57_payments, 
      :collection_issues_58_installme, 
      :collection_issues_59_offer_in, 
      :collection_issues_60_currently, 
      :collection_issues_61_liens, 
      :collection_issues_62_levies_in, 
      :total_case_issues_worked_add_l, 
      :case_inventory_1a_beginning_ca, 
      :case_inventory_1b_new_cases_op, 
      :case_inventory_1c_total_number, 
      :case_inventory_1d_cases_closed, 
      :case_inventory_1e_ending_case, 
      :accounts_management_2a_return, 
      :accounts_management_2b_penalty, 
      :accounts_management_2c_injured, 
      :accounts_management_2d_backup, 
      :exams_2e_correspondence_exam, 
      :exams_2f_office_or_field_exam, 
      :exams_2g_automated_underreport, 
      :exams_2h_automated_substitute, 
      :exams_2i_audit_reconsideration, 
      :collection_2j_automated_collec, 
      :collection_2k_field_collection, 
      :collection_2l_offer_in_comprom, 
      :collection_2m_lien_unit, 
      :collection_2n_bankruptcy, 
      :appeals_2o_exam_appeals, 
      :appeals_2p_collection_due_proc, 
      :appeals_2q_collection_appeals, 
      :appeals_2r_oic_appeals, 
      :appeals_2s_penalty_abatement_a, 
      :appeals_2t_other_appeals, 
      :litigation_2u_us_tax_court, 
      :litigation_2v_other_federal_co, 
      :miscellaneous_2w_identity_prot, 
      :miscellaneous_2x_innocent_spou, 
      :miscellaneous_2y_ss_8_unit, 
      :miscellaneous_2z_itin_unit, 
      :miscellaneous_2aa_trust_fund_r, 
      :total_add_items_2a_through_2aa, 
      :additional_case_information_3, 
      :additional_case_information_4, 
      :additional_case_information_5, 
      :additional_case_information_6, 
      :additional_case_information_7, 
      :additional_case_information_8, 
      :additional_case_information_9, 
      :additional_case_information_10, 
      :us_tax_court_activities_12_num, 
      :us_tax_court_activities_13_num, 
      :us_tax_court_activities_14_num, 
      :closed_case_outcomes_15a_numbe, 
      :closed_case_outcomes_15b_numbe, 
      :closed_case_outcomes_15c_total, 
      :closed_case_outcomes_15d_total)
  end
end
