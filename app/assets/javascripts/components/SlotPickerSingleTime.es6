(function() {
  'use strict';

  class SlotPickerSingleTime extends PWPG.BaseComponent {
    constructor($component, $form) {
      super($component);

      this.$form = $form;
      this.ajaxLoaderHtml = this.$component.find('#slot-picker-ajax-loader').html();
      this.errorHtml = this.$component.find('#slot-picker-error').html();
      this.headerSelector = '.js-slot-picker-header';
      this.errorHeaderSelector = '.js-slot-picker-error-header';

      $.subscribe('slot-picker-day-selected', this.handleDaySelected.bind(this));
    }

    handleDaySelected(event, dayButton) {
      this.displayAjaxLoader();
      this.requestTimes($(dayButton).val());
    }

    displayAjaxLoader() {
      this.ajaxLoaderTimeout = setTimeout(() => {
        this.$component.html(this.ajaxLoaderHtml);
      }, 200);
    }

    requestTimes(date) {
      $.post(
        this.$form.attr('action'),
        {
          'telephone_appointment[step]': 2,
          'telephone_appointment[selected_date]': date,
          'authenticity_token': this.$form.find('input[name=authenticity_token]').val()
        }
      )
      .done(this.displayTimes.bind(this))
      .fail(this.displayError.bind(this));
    }

    displayTimes(html) {
      clearTimeout(this.ajaxLoaderTimeout);
      this.$component.html(html);
      this.getTimesHeader()
        .attr('tabindex', -1)
        .focus()
        .removeAttr('tabindex');
    }

    displayError() {
      clearTimeout(this.ajaxLoaderTimeout);
      this.$component.html(this.errorHtml);
      this.getErrorHeader()
        .focus()
        .removeAttr('tabindex');
    }

    getTimesHeader() {
      return this.$component.find(this.headerSelector);
    }

    getErrorHeader() {
      return this.$component.find(this.errorHeaderSelector);
    }
  }

  window.PWPG = window.PWPG || {};
  window.PWPG.SlotPickerSingleTime = SlotPickerSingleTime;
})();
