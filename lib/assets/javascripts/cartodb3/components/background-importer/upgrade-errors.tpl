<div class="Dialog-header">
  <div class="Dialog-headerIcon Dialog-headerIcon--negative u-flex u-alignCenter u-justifyCenter">
    <i class="CDB-IconFont CDB-IconFont-barometer"></i>
  </div>
  <h2 class="CDB-Text CDB-Size-large u-bSpace u-errorTextColor">
    <%- _t('components.background-importer.upgrade-errors.' + errorCode + '.title') %>
  </h2>
  <h3 class="CDB-Text CDB-Size-medium u-secondaryTextColor">
    <%- _t('components.background-importer.upgrade-errors.' + errorCode + '.description') %>
  </h3>
</div>

<div class="Dialog-body ErrorDetails-body">
  <ul class="Modal-containerList">
    <li class="ErrorDetails-itemStep">
      <div class="ErrorDetails-itemIcon CDB-Text CDB-Size-medium is-semibold u-flex u-alignCenter u-justifyCenter">
        <i class="CDB-IconFont CDB-IconFont-rocket"></i>
      </div>
      <div class="ErrorDetails-itemText">
        <p class="CDB-Text CDB-Size-medium">
          <%- _t('components.background-importer.upgrade-errors.' + errorCode + '.info') %>
        </p>
        <% if (showTrial) { %>
          <p class="CDB-Text CDB-Size-small">
            <%- _t('components.background-importer.free-trial', { days: 14 }) %>
          </p>
        <% } %>
      </div>
    </li>
  </ul>
</div>

<div class="Dialog-footer--simple u-inner">
  <button href="<%- upgradeUrl %>" class="CDB-Button CDB-Button--primary u-tSpace--m js-confirm">
    <span class="CDB-Button-Text CDB-Text is-semibold CDB-Size-medium u-upperCase">
      <%- _t('components.background-importer.upgrade-errors.upgrade') %>
    </span>
  </button>
</div>
