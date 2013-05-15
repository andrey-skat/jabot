require 'spec_helper'

describe Jabot::Commands do

  let(:command_line) { 'test John Green' }

  before :each do
    subject.add_command :test do |name, color|
      'Test'
    end
  end

  it 'should add command' do
    subject.command_exists?(:test).should be_true
  end

  it 'should return list of available commands' do
    subject.available_commands.should == [{
        name: 'test',
        args: 'name, color'
    }]
  end

  it 'should parse input message' do
    subject.parse(command_line).should == {
        name: :test,
        args: %w(John Green)
    }
  end

  it 'should run a command' do
    subject.run(command_line).should == 'Test'
  end

  it 'should raise error if command not found' do
    expect { subject.run('test_1 John Green') }.to raise_error
  end

end