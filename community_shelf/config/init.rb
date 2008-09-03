#
# ==== Structure of Merb initializer
#
# 1. Load paths.

Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

Merb.push_path(:lib, Merb.root / :lib)

# 2. Dependencies configuration.

require 'isbn/tools'
require 'openid'
require 'openid/store/filesystem'
require 'dm-aggregates'
require 'dm-is-permalink'
require 'dm-paginate'
require 'dm-timestamps'
require 'dm-types'
require 'dm-validations'
require 'merb-action-args'
require 'merb-assets'
require "merb_helpers"

# 3. Libraries (ORM, testing tool, etc) you use.

use_orm :datamapper

use_test :rspec, 'dm-sweatshop'

use_template_engine :haml

# 4. Application-specific configuration.

Merb::Config.use do |c|
  c[:session_id_key] = 'community_shelf_session_id'
  c[:session_secret_key]  = '83555ebe6864a546342963719b6600e65b986558'
  c[:session_store] = 'cookie'
end

# ==== Tune your inflector

# ==== Callback/Bootloader classes