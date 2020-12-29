# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Arrow
  module ColumnContainable
    def columns
      @columns ||= schema.n_fields.times.collect do |i|
        Column.new(self, i)
      end
    end

    def each_column(&block)
      columns.each(&block)
    end

    def find_column(name_or_index)
      case name_or_index
      when String, Symbol
        name = name_or_index.to_s
        index = schema.get_field_index(name)
        return nil if index == -1
        Column.new(self, index)
      when Integer
        index = name_or_index
        index += n_columns if index < 0
        return nil if index < 0 or index >= n_columns
        Column.new(self, index)
      else
        message = "column name or index must be String, Symbol or Integer"
        raise ArgumentError, message
      end
    end
  end
end
