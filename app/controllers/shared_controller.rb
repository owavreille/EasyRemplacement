class SharedController < ApplicationController
    def calendar_partial
        @site = Site.find_by(id: params[:site_id])
        @events = @site ? @site.events.where('start_time >= ?', Date.today) : Event.where('start_time >= ?', Date.today)
        @event = Event.all
      render partial: 'shared/calendar_partial_4_days'
    end
  end
  