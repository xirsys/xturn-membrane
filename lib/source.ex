### ----------------------------------------------------------------------
###
### Copyright (c) 2013 - 2018 Lee Sylvester and Xirsys LLC <experts@xirsys.com>
###
### All rights reserved.
###
### XTurn is licensed by Xirsys under the Apache
### License, Version 2.0. (the "License");
###
### you may not use this file except in compliance with the License.
### You may obtain a copy of the License at
###
###      http://www.apache.org/licenses/LICENSE-2.0
###
### Unless required by applicable law or agreed to in writing, software
### distributed under the License is distributed on an "AS IS" BASIS,
### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
### See the License for the specific language governing permissions and
### limitations under the License.
###
### See LICENSE for the full license text.
###
### ----------------------------------------------------------------------

defmodule Xirsys.XTurn.Membrane.Source do
  @moduledoc """
  """
  use Membrane.Element.Base.Source
  require Logger
  @vsn "0"
  @stun_marker 0

  alias XMediaLib.Stun
  alias Membrane.{Buffer, Event}
  alias Membrane.Element.File.CommonFile

  import Mockery.Macro

  #########################################################################################################################
  # Membrane functions
  #########################################################################################################################

  def_options src: [type: :string, description: "Path to the file"],
              chunk_size: [
                type: :integer,
                spec: pos_integer,
                default: 2048,
                description: "Size of chunks being read"
              ]

  def_output_pad :output, caps: :any

  # Private API

  @impl true
  def handle_init(%__MODULE__{location: location, chunk_size: size}) do
    {:ok,
     %{
       location: location,
       chunk_size: size,
       fd: nil
     }}
  end

  @impl true
  def handle_stopped_to_prepared(_ctx, state), do: mockable(CommonFile).open(:read, state)

  @impl true
  def handle_demand(:output, _size, :buffers, _ctx, %{chunk_size: chunk_size} = state),
    do: supply_demand(chunk_size, [redemand: :output], state)

  def handle_demand(:output, size, :bytes, _ctx, state),
    do: supply_demand(size, [], state)

  def supply_demand(size, redemand, %{fd: fd} = state) do
    with <<payload::binary>> <- fd |> mockable(CommonFile).binread(size) do
      {{:ok, [buffer: {:output, %Buffer{payload: payload}}] ++ redemand}, state}
    else
      :eof -> {{:ok, event: {:output, %Event.EndOfStream{}}}, state}
      {:error, reason} -> {{:error, {:read_file, reason}}, state}
    end
  end

  @impl true
  def handle_prepared_to_stopped(_ctx, state), do: mockable(CommonFile).close(state)

  #########################################################################################################################
  # Private functions
  #########################################################################################################################
end
