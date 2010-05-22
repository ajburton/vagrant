require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class CommandsDestroyTest < Test::Unit::TestCase
  setup do
    @klass = Vagrant::Commands::Destroy

    @env = mock_environment

    @instance = @klass.new(@env)
  end

  context "executing" do
    should "call destroy_all if no name is given" do
      @instance.expects(:destroy_all).once
      @instance.execute
    end

    should "call destroy_single if a name is given" do
      @instance.expects(:destroy_single).with("foo").once
      @instance.execute(["foo"])
    end
  end

  context "destroying all" do
    should "destroy each VM" do
      vms = { :foo => nil, :bar => nil, :baz => nil }
      @env.stubs(:vms).returns(vms)

      vms.each do |name, value|
        @instance.expects(:destroy_single).with(name).once
      end

      @instance.destroy_all
    end
  end

  context "destroying a single VM" do
    setup do
      @foo_vm = mock("vm")
      @foo_vm.stubs(:env).returns(@env)
      vms = { :foo => @foo_vm }
      @env.stubs(:vms).returns(vms)
    end
    should "error and exit if the VM doesn't exist" do
      @env.stubs(:vms).returns({})
      @instance.expects(:error_and_exit).with(:unknown_vm, :vm => :foo).once
      @instance.destroy_single(:foo)
    end

    should "destroy if its created" do
      @foo_vm.stubs(:created?).returns(true)
      @foo_vm.expects(:destroy).once
      @instance.destroy_single(:foo)
    end

    should "do nothing if its not created" do
      @foo_vm.stubs(:created?).returns(false)
      @foo_vm.expects(:destroy).never
      @instance.destroy_single(:foo)
    end
  end
end