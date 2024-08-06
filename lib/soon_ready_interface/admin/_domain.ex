defmodule SoonReadyInterface.Admin.Domain do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do

  end
end
