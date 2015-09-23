class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks, force: true do |table|
      # priority field allows us to set priority for different tasks
      # in simpliest way we can just take high-to-low priority tasks using ORDER BY
      table.integer :priority, default: 0, null: false
      # handler is a name of the handler method of our task.
      table.string :handler
      # argument is a field in which params to handler method is stored.
      # the most questionable part: (TODO: check it and find more pretty store form if needed)
      # different handler methods have different number of params to go,
      # so we need to store them all in one, monotonously way.
      # one of the simpliest way is to serialized it. We can do it in number of ways:

      # 1. do it with standart Marshal:
      #   params = ['dfp', 'Countries', 'some_other_argument', 42, nil, :bar]
      #   serialized_arguments = Marshal.dump(params)
      #   retrieve data:
      #   deserialized_params = Marshal.load(serialized_arguments)

      # 2. Use json/yaml format to store data (almost the same way as Marshal)

      # 3. Use ActiveRecord's serialize declaration
      #   serialize :argument
      #    ...
      #   task = Task.new
      #   task.argument = ['dfp', 'Company']
      #   task.save
      table.text :argument

      # a way to select sources
      table.string :channel

      # status is a string to explicit check of task.
      # status can be: "new", "doing". "done", "failure"
      table.string :status, default: "new", null: false

      # number of attemts to comlete the task.
      # a way to check queue for number of failures
      table.integer :attempts, default: 0, null: false
      table.text :last_error
      table.datetime :failed_at

      # a way to check the parent of curent task
      # if we need to make reference to same table (tasks) we need to use self joins [http://guides.rubyonrails.org/association_basics.html#self-joins]
      # table.references :parent_task, index: true

      table.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
