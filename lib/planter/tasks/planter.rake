# Bootstrap qa data using Planter. Additional Information about how Planter
# is implemented can be found at https://github.com/ableco/fino/wiki/Bootstrapping-QA-data.
namespace :planter do
  desc "Runs default seed file and all issue specific seed files"
  task seed: [:environment] do
    Planter::Bootstrapper.seed
  end

  desc "Runs default deseed file and all issue specific deseed files"
  task deseed: [:environment] do
    Planter::Bootstrapper.deseed
  end
end
