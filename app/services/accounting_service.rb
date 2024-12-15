
class AccountingService
  def self.calculate_totals(events, group_by: nil)
    {
      amount: group_and_sum(events, :amount, group_by),
      amount_paid: group_and_sum(events, :amount_paid, group_by),
      amount_earned: group_and_sum(events, 'events.amount - events.amount_paid', group_by)
    }
  end

  def self.calculate_totals_by_entity(events, entity)
    {
      amount: group_and_sum_by_entity(events, entity, :amount),
      amount_paid: group_and_sum_by_entity(events, entity, :amount_paid),
      amount_earned: group_and_sum_by_entity(events, entity, 'events.amount - events.amount_paid')
    }
  end

  private

  def self.group_and_sum(events, column, group_by)
    return events.sum(column) unless group_by

    case group_by
    when :month
      events.group("strftime('%m', start_time)").sum(column)
    when :year
      events.group("strftime('%Y', start_time)").sum(column)
    else
      events.sum(column)
    end
  end

  def self.group_and_sum_by_entity(events, entity, column)
    grouped_data = events
      .joins(entity)
      .group("#{entity.to_s.pluralize}.id")
      .sum(column)

    entity_class = entity.to_s.camelize.constantize
    entity_names = case entity
                  when :site
                    entity_class.where(id: grouped_data.keys).pluck(:name)
                  when :doctor, :user
                    entity_class
                      .where(id: grouped_data.keys)
                      .pluck(:first_name, :last_name)
                      .map { |first, last| "#{first} #{last}" }
                  end
    
    Hash[entity_names.zip(grouped_data.values)]
  end
end
