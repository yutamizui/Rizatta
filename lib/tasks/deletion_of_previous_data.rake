namespace :entire_site do  ## --  Delete data(timeframe, reservaton, ticket) older than 12 months --  ##
  desc "deletion_of_previous_data"
  task deletion_of_previous_data: :environment do
    @tickets = Ticket.where("expired_at < ?", Date.today.in_time_zone.end_of_day)
    if @tickets.present?
      @tickets.destroy_all
    end

    @timeframes = Timeframe.where("target_date < ?", Date.today.ago(11.month).end_of_month)
    if @timeframes.present?
      @timeframes.each do |t|
        @reservations = Reservation.where(timeframe_id: t.id)
        @reservations.destroy_all
      end
      @timeframes.destroy_all
    end
  end
end