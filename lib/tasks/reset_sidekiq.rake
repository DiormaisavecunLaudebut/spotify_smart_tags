desc 'clear all queues, delete workers, retries and planned jobs'

task :reset_sidekiq do
  Sidekiq::Queue.all.each(&:clear)
  Sidekiq::RetrySet.new.clear
  Sidekiq::ScheduledSet.new.clear
  Sidekiq::DeadSet.new.clear
end
