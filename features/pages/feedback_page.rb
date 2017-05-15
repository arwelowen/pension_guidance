require_relative '../sections/feedback'

module Pages
  class Feedback < Page
    set_url '/{locale}/feedback/new'

    section :feedback, Sections::Feedback, '.t-feedback'

    elements :errors, '.error-message'
  end
end
