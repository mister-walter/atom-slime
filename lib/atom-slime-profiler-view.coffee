{CompositeDisposable} = require 'atom'
{$} = require 'atom-space-pen-views'
Dialog = require './dialog'

module.exports =
class ProfilerView
  constructor: (sw) ->
    @swank = sw
    @enabled = false
    @content = $('<div>').addClass('inline-block')
    @content.css({'max-width':'100vw', 'margin-left':'13px'}) # Prevent from getting cut off
    @main = $('<div>')
    @content.append(@main)

  toggle: ->
    if @enabled
      @main.html('')
      @enabled = false
    else
      prof_menu = '<b>Profile</b>: '
      prof_menu += '&nbsp;&nbsp;&nbsp; <a href="#" id="prof-func">Function</a> '
      prof_menu += '&nbsp;&middot;&nbsp; <a href="#" id="prof-pack">Package</a> '
      prof_menu += '&nbsp;&middot;&nbsp; <a href="#" id="prof-unprof">Unprofile All</a> '
      prof_menu += '&nbsp;&middot;&nbsp; <a href="#" id="prof-reset">Reset Data</a> '
      prof_menu += '&nbsp;&middot;&nbsp; <a href="#" id="prof-report">Report</a>'
      @main.html(prof_menu)
      @setup()
      @enabled = true

  setup: ->
    $('#prof-func').on 'click', (event) =>
      @profile_function_click_handler event
    $('#prof-pack').on 'click', (event) =>
      @profile_package_click_handler event
    $('#prof-unprof').on 'click', (event) =>
      @unprofile_click_handler event
    $('#prof-report').on 'click', (event) =>
      @report_click_handler event
    $('#prof-reset').on 'click', (event) =>
      @reset_click_handler event
    return

  unprofile_click_handler: ->
    @swank.profile_invoke_unprofile_all()

  report_click_handler: ->
    @swank.profile_invoke_report()

  reset_click_handler: ->
    @swank.profile_invoke_reset()

  profile_function_click_handler: ->
    func_dialog = new Dialog({prompt: "Enter Function", forpackage: false})
    func_dialog.attach(((sw) -> ((func) -> sw.profile_invoke_toggle_function(func)))(@swank), false)

  profile_package_click_handler: ->
    func_dialog = new Dialog({prompt: "Enter Package", forpackage: true})
    func_dialog.attach(((sw) -> ((pack,rec_calls,prof_meth) -> sw.profile_invoke_toggle_package(pack,rec_calls,prof_meth)))(@swank), true)

  attach: (@statusBar) ->
    @statusBar.addLeftTile(item: @content[0], priority: 9)

  destroy: ->
    @content.remove()

  getTitle: -> "Profiler"
  getURI: -> "slime://profile"
  isEqual: (other) ->
    other instanceof ProfilerView
