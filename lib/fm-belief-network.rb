# ================
# = Dependencies =
# ================
# Short term:
require File.expand_path('../../../fathom/lib/fathom', __FILE__)
require 'rubygems'
require 'sqlite3'

require 'fathom'
module Fathom
  class Config

    def initialize
      @uses_sqlite_optimizer = true
    end
    
    attr_writer :set_storage
    def set_storage
      @set_storage ||= ":memory:"
    end

    def db
      @db ||= SQLite3::Database.new(set_storage)
    end
    
    attr_reader :uses_sqlite_optimizer
    def uses_sqlite_optimizer=(value)
      @uses_sqlite_optimizer = value
      @db = :not_implemented unless value
    end

  end
end

def path(path)
  File.expand_path("../fathom/#{path}", __FILE__)
end

# ==========
# = Errors =
# ==========
class NotImplemented < StandardError
end

# ========
# = Data =
# ========
Fathom.autoload :CPT, path('data/cpt')
Fathom::Variable
require path('data/variable')

# ============
# = Contexts =
# ============
Fathom.autoload :ManualEntryContext, path('contexts/network/manual_entry_context')
Fathom.autoload :CPTBuilderContext, path('contexts/cpt/cpt_builder_context')
Fathom.autoload :CPTReporterContext, path('contexts/cpt/cpt_reporter_context')

# =========
# = Roles =
# =========
# Fathom.autoload :BeliefInspector, path('roles/matrix/belief_inspector')
Fathom.autoload :BeliefPropagator, path('roles/network/belief_propagator')
Fathom.autoload :CPTBuilder, path('roles/cpt/cpt_builder')
Fathom.autoload :CPTReporter, path('roles/cpt/cpt_reporter')
Fathom.autoload :BeliefNetworkBuilder, path('roles/network/belief_network_builder')


