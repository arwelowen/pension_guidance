class TelephoneAppointmentsController < ApplicationController
  layout 'full_width'

  before_action :set_breadcrumbs
  before_action :telephone_appointment, only: %i(new create)
  before_action only: %i(new create) do
    @feedback = FeedbackForm.for_online_booking
    retrieve_slots
  end

  def new
  end

  def create
    send("create_step_#{telephone_appointment.step}")
  end

  def confirmation
    @booking_reference = flash[:booking_reference]
    @booking_date      = Time.zone.parse(flash[:booking_date])
  end

  private

  def telephone_appointment
    @telephone_appointment ||= TelephoneAppointment.new(telephone_appointment_params)
  end

  def create_step_1
    telephone_appointment.advance! { render :new }
  end

  def create_step_2
    if request.xhr?
      render partial: 'times', locals: { times: @times }
    else
      telephone_appointment.advance! { render :new }
    end
  end

  def create_step_3
    if telephone_appointment.ineligible?
      redirect_to ineligible_telephone_appointments_path
    elsif telephone_appointment.invalid?
      render :new
    elsif telephone_appointment.save
      confirm_to_customer(telephone_appointment)
    else
      @slot_assignment_failed = true
      telephone_appointment.reset! { render :new }
    end
  end

  def confirm_to_customer(telephone_appointment)
    redirect_to(
      confirmation_telephone_appointments_path,
      flash: {
        booking_reference: telephone_appointment.id,
        booking_date: telephone_appointment.start_at
      }
    )
  end

  def retrieve_slots
    slots   = TelephoneAppointmentsApi.new.slots

    @months = retrieve_months(slots)
    @times  = retrieve_times(slots)
  end

  def retrieve_months(slots)
    default_months = Hash.new { |h, k| h[k] = [] }
    available_days = slots.keys.map(&:to_date)

    available_days.each_with_object(default_months) do |day, months|
      months[day.beginning_of_month] << day
    end
  end

  def retrieve_times(slots)
    return unless telephone_appointment.selected_date

    key = telephone_appointment.selected_date.strftime('%Y-%m-%d')
    slots[key].map { |d| DateTime.parse(d).in_time_zone }
  end

  def telephone_appointment_params # rubocop:disable Metrics/MethodLength
    params
      .fetch(:telephone_appointment, {})
      .permit(
        :step,
        :selected_date,
        :start_at,
        :first_name,
        :last_name,
        :email,
        :phone,
        :memorable_word,
        :date_of_birth,
        :dc_pot_confirmed,
        :opt_out_of_market_research,
        :accept_terms_and_conditions,
        :date_of_birth_year,
        :date_of_birth_month,
        :date_of_birth_day
      )
  end

  def set_breadcrumbs
    breadcrumb Breadcrumb.book_an_appointment
    breadcrumb Breadcrumb.book_a_telephone_appointment
  end
end
