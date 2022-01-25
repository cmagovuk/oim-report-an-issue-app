class ReportIssues::StepWorkflow
  attr_reader :request

  ORG_STEPS = %w[reporting_as org_name postcode org_area org_sector issue issue_areas supporting_documents contact_details summary].freeze
  IND_STEPS = %w[reporting_as postcode issue issue_areas supporting_documents contact_details summary].freeze

  def initialize(request)
    @request = request
  end

  def step_model
    sub_class = begin
      "ReportIssue::#{step.camelcase}".constantize
    rescue StandardError
      ReportIssue
    end
    @step_model ||= sub_class.find(session[:issue_id])
  end

  def next_step
    if completed_steps?
      step_set.last unless step == step_set.last
    else
      current_step_index = step_set.index(step)
      step_set[current_step_index + 1]
    end
  end

  def step_valid?
    step_set.include? step if step.present?
  end

  def step
    @step ||= params[:id].to_s.downcase
  end

  def update_completed_steps
    array = step_model.completed_steps.map { |o| o }
    step_model.update!(completed_steps: array.append(step)) unless array.include?(step)
  end

  def previous_step
    if completed_steps? && step != step_set.last
      step_set.last
    else
      current_step_index = step_set.index(step)
      previous_step_index = current_step_index - 1
      previous_step_index.negative? ? nil : step_set[previous_step_index]
    end
  end

  def missed_step
    uncompleted_steps[0]
  end

  def first_step
    ORG_STEPS.first
  end

  def completed_steps?
    uncompleted_steps.empty?
  end

private

  def session
    request.session
  end

  def params
    request.params
  end

  def step_set
    if step_model.individual_reporting?
      IND_STEPS
    else
      ORG_STEPS
    end
  end

  def uncompleted_steps
    step_set[0..-2].difference(step_model.completed_steps)
  end
end
