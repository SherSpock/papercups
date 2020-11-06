module ChatApi.Kits.KitAssembler do
  @moduledoc """
  Storage and assembly for Kits -- persistible structs that have not yet been persisted.

  Also contains type definitions for Kit and AssembledKit.
  """

  @typedoc """
  A persistible/assemblable struct that has not yet been persisted/assembled.
  """
  @type Kit :: %{
    id: nil,
    __struct__: String.t()
  }

  @typedoc """
  A Kit that has been assembled.
  """
  @type AssembledKit :: %{
    id: integer() | String.t(),
    __struct__: String.t()
  }

  @doc """
  An assemblable Kit.

  Takes a map that should contain any additionally required attributes/parts needed to
  make it assemblable (and nothing more).

  For Kits that do not require db associations, it is recommended that this be a bare
  wrapper around a defined `complete/0`. It is further recommended that, in this context,
  `complete/1` not be called to alter a given Kit -- the KitAdjuster module should be
  used instead.

  For Kits that *do* require db associations, it is recommended that the map of
  attributes/parts passed to `complete/1` only be used to ready a Kit to be
  assembled. To alter ad hoc a Kit for reasons other than validity, the KitAdjuster
  module should be used.
  """
  @callback complete(map()) :: Kit

  @doc """
  An assemblable Kit.

  This should only be defined on implementers of KitAssembler whose Kits do not
  require db associations in order to be assembled.
  """
  @callback complete :: Kit
  @optional_callbacks: complete: 0

  @doc """
  An unassemblable Kit.

  For Kits that do not require db associations, it is recommended that this hold a
  bare struct.

  For Kits that *do* require db associations, it is recommended that this hold an otherwise
  complete Kit, minus the required associations. It can then be used in tandem with the
  KitAdjuster module to define a convention-adhering `complete/1` function.

  If you have a struct that can be persisted on initialization without any additional input
  there is probably something wrong with your data model -- this use case will never be
  supported.
  """
  @callback incomplete :: Kit

  @doc """
  Persistence function for a Kit.
  """
  @callback assemble(Kit) :: {:ok, AssembledKit} | {:error, Ecto.Changeset.t}
end
