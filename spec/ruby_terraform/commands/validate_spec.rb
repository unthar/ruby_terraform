require 'spec_helper'

describe RubyTerraform::Commands::Validate do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform validate command passing the supplied directory' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform validate some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Validate.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary validate some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'adds a var option for each supplied var' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var 'first=1' -var 'second=two' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            first: 1,
            second: 'two'
        })
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -state=some/state.tfstate some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        state: 'some/state.tfstate')
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform validate -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true)
  end

  it 'adds a var-file option if a var file is provided' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var-file=some/vars.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars')
  end
end
