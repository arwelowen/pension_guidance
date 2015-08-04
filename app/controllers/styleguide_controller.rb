class StyleguideController < ApplicationController
  layout 'styleguide/full_width'

  def pages_homepage
    render template: 'styleguide/pages/homepage'
  end

  def pages_guide
    render template: 'styleguide/pages/guide'
  end

  def pages_journey_index
    render template: 'styleguide/pages/journey_index'
  end

  def pages_journey_page
    render template: 'styleguide/pages/journey_page'
  end

  def pages_locations_search
    render template: 'styleguide/pages/locations_search',
           layout: 'styleguide/pages'
  end

  def pages_locations_index
    render template: 'styleguide/pages/locations_index',
           layout: 'styleguide/pages'
  end

  def pages_locations_invalid
    render template: 'styleguide/pages/locations_invalid',
           layout: 'styleguide/pages'
  end

  def pages_locations_show
    render template: 'styleguide/pages/locations_show',
           layout: 'styleguide/pages'
  end

  def pages_locations_show_call_centre
    render template: 'styleguide/pages/locations_show_call_centre',
           layout: 'styleguide/pages'
  end
end
