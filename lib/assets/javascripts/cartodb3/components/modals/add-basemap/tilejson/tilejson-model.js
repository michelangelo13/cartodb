var Backbone = require('backbone');
var _ = require('underscore');
var TileJSONView = require('./tilejson-view');

/**
 * View model for TileJSON tab content.
 */
module.exports = Backbone.Model.extend({

  defaults: {
    name: 'tilejson',
    label: 'TileJSON',
    layer: undefined // will be set when valid
  },

  createView: function (opts) {
    if (!opts.submitButton) throw new Error('submitButton is required');
    if (!opts.modalFooter) throw new Error('modalFooter is required');

    this._submitButton = opts.submitButton;
    this._modalFooter = opts.modalFooter;

    return new TileJSONView({
      model: this,
      submitButton: this._submitButton,
      modalFooter: this._modalFooter
    });
  },

  hasAlreadyAddedLayer: function (userLayers) {
    var urlTemplate = this.get('layer').get('urlTemplate');
    return _.any(userLayers.isCustomCategory(), function (customLayer) {
      return customLayer.get('urlTemplate') === urlTemplate;
    });
  }

});