%setdefault('app', None)
%setdefault('user', None)

%username = 'anonymous'
%if user is not None:
%if hasattr(user, 'alias') and user.alias != 'none':
%	username = user.alias
%else:
%	username = user.get_name()
%end
%end


<!-- Header Navbar -->
<nav class="header navbar navbar-default navbar-static-top" style="margin-bottom:0px;">
  <div class="navbar-header">
    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
      <span class="sr-only">Toggle navigation</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <a href="#about" data-toggle="modal" data-target="#about" class="logo navbar-brand">
      <img src="/static/logo/{{app.company_logo}}" alt="Company logo" />
    </a>
  </div>
  <!-- Collect the nav links, forms, and other content for toggling -->
  <ul class="nav navbar-nav">
    <!-- Host search ... -->

    %include("_filters.tpl")

    <!-- Clock ... -->
    <!--<p class="navbar-text hidden-sm hidden-xs hidden-md">-->
      <!--<span class="headClock">-->
        <!--<span class="date">&nbsp;</span> - <span class="time">&nbsp;</span>-->
      <!--</span>-->
    <!--</p>-->
  </ul>

  <!-- Right buttons ... -->
%synthesis = helper.get_synthesis(app.get_all_hosts_and_services(user))
%s = synthesis['services']
%h = synthesis['hosts']
  <ul class="nav navbar-top-links navbar-right">
    <li>
      %host_state = app.get_percentage_hosts_state(app.get_user_auth(), False)
       <a class="quickinfo states" href="/all?search=type:host" data-original-title="Hosts states" data-toggle="popover" title="Overall hosts states, {{h['nb_elts']}} hosts" data-html="true" data-trigger="hover" data-placement="bottom" data-content='
            <table class="table table-invisible table-condensed">
               <tbody>
                  <tr>
                     %for state in "up", "unreachable", "down", "pending", "unknown", "ack", "downtime":
                     <td>
                       %label = "%s <i>(%s%%)</i>" % (h['nb_' + state], h['pct_' + state])
                       {{!helper.get_fa_icon_state_and_label(cls="host", state=state, label=label, disabled=(not h["nb_" + state]))}}
                     </td>
                     %end
                  </tr>
               </tbody>
            </table>
         '>
         <i class="fa fa-server"></i>
         %state = 100.0-h['pct_up']
         %threshold_warning=5.0
         %threshold_critical=10.0
         %label='success' if state < threshold_warning else 'warning' if state < threshold_critical else 'danger'
         <span class="label label-as-badge label-{{label}}">{{host_state}}%</span>
       </a>
    </li>
   
    <li>
      %service_state = app.get_percentage_service_state(app.get_user_auth(), False)
       <a class="quickinfo states" href="/all?search=type:service" data-original-title="Services states" data-toggle="popover" title="Overall services states, {{s['nb_elts']}} services" data-html="true" data-trigger="hover" data-placement="bottom" data-content='
            <table class="table table-invisible table-condensed">
               <tbody>
                  <tr>
                     %for state in "ok", "warning", "critical", "pending", "unknown", "ack", "downtime":
                     <td>
                       %label = "%s <i>(%s%%)</i>" % (s["nb_" + state], s["pct_" + state])
                       {{!helper.get_fa_icon_state_and_label(cls="service", state=state, label=label, disabled=(not s["nb_" + state]))}}
                     </td>
                     %end
                  </tr>
               </tbody>
            </table>
         '>
         <i class="fa fa-bars"></i>
         %state = 100-s['pct_ok']
         %threshold_warning=5.0
         %threshold_critical=10.0
         %label='success' if state < threshold_warning else 'warning' if state < threshold_critical else 'danger'
         <span class="label label-as-badge label-{{label}}">{{service_state}}%</span>
       </a>
    </li>
    
    <li>
      <a class="quickinfo" data-original-title='Currently' href="/dashboard/currently" title="Currently">
         <i class="fa fa-eye"></i>
      </a>
    </li>

    %if refresh:
    <li>
       <a class="quickinfo" data-original-title='Refreshing' title="Automatic refresh" href="javascript:toggle_refresh()">
         <i id="header_loading" class="fa fa-refresh"></i>
       </a>
    </li>
    %end
   
    <!-- User info -->
    <li class="dropdown user user-menu">
      <a href="#" class="dropdown-toggle" data-original-title='User menu' data-toggle="dropdown">
        <i class="fa fa-user"></i>
        <span><span class="username hidden-sm hidden-xs hidden-md">{{username}}</span> <i class="caret"></i></span>
      </a>

      <ul class="dropdown-menu">
        <li class="user-header">
          <div class="panel panel-info" id="user_info">
            <div class="panel-body panel-default">
              <!-- User image / name -->
              <p class="username">{{username}}</p>
              %if app.can_action():
              <p class="usercategory">
                <small>{{'Administrator' if user.is_admin else 'User'}}</small>
              </p>
              %end
              <img src="{{app.user_picture}}" class="img-circle user-logo" alt="{{username}}" title="Photo: {{username}}">
            </div>
            <div class="panel-footer">
              <!-- User actions -->
              <div class="btn-group" role="group">
                <a href="https://shinken.readthedocs.org/en/latest/" target="_blank" class="btn btn-default btn-flat"><i class="fa fa-book"></i> </a>
              </div>
              <div class="btn-group" role="group">
                <a href="#actions" data-toggle="modal" class="btn btn-default btn-flat disabled"><span class="fa fa-gear"></span> </a>
                <a href="/user/pref" data-toggle="modal" class="btn btn-default btn-flat"><span class="fa fa-pencil"></span> </a>
              </div>
              <div class="btn-group" role="group">
                <a href="/user/logout" class="btn btn-default btn-flat" data-toggle="modal" data-target="/user/logout"><span class="fa fa-sign-out"></span> </a>
              </div>
            </div>
          </div>
        </li>
      </ul>
    </li>
  </ul>


  <!--SIDEBAR-->
  <div class="navbar-default sidebar" role="navigation">
    <div class="sidebar-nav navbar-collapse">
      <ul class="nav" id="sidebar-menu">
        %if app:
        <li> <a href="/dashboard"> <span class="fa fa-dashboard"></span> Dashboard </a> </li>
        <li> <a href="/all?search=isnot:UP isnot:OK isnot:PENDING ack:false downtime:false"> <span class="fa fa-ambulance"></span> Problems </a> </li>
        <li> <a href="#"><i class="fa fa-sitemap"></i> Groups and tags <i class="fa arrow"></i></a>
          <ul class="nav nav-second-level">
            <li> <a href="/hosts-groups"> <span class="fa fa-sitemap"></span> Hosts groups </a> </li>
            <li> <a href="/services-groups"> <span class="fa fa-sitemap"></span> Services groups </a> </li>
            <li> <a href="/hosts-tags"> <span class="fa fa-tags"></span> Hosts tags </a> </li>
            <li> <a href="/services-tags"> <span class="fa fa-tags"></span> Services tags </a> </li>
          </ul>
        </li>
        <li> <a href="#"><i class="fa fa-bar-chart"></i> Tactical views <i class="fa arrow"></i></a>
          <ul class="nav nav-second-level">
            <li> <a href="/impacts"> <span class="fa fa-bolt"></span> Impacts </a> </li>
            <li> <a href="/minemap"> <span class="fa fa-table"></span> Minemap </a> </li>
            <li> <a href="/worldmap"> <span class="fa fa-globe"></span> World map </a> </li>
            <li> <a href="/wall"> <span class="fa fa-th-large"></span> Wall </a> </li>
          </ul>
        </li>
        <li> <a href="#"><i class="fa fa-gears"></i> System <i class="fa arrow"></i></a>
          <ul class="nav nav-second-level">
            <li> <a href="/parameters"> <span class="fa fa-gears"></span> Configuration </a> </li>
            <li> <a href="/system"> <span class="fa fa-gears"></span> Status </a> </li>
            <li> <a href="/logs"> <span class="fa fa-th-list"></span> Logs </a> </li>
            <li> <a href="/availability"> <span class="fa fa-bar-chart"></span> Availability </a> </li>
          </ul>
        </li>
        <!--<li> <a href="/shinken-io"> <span class="fa fa-gears"></span> Shinken IO </a> </li>-->
        <li> <a href="#"><i class="fa fa-wrench"></i> Configuration <i class="fa arrow"></i></a>
          <ul class="nav nav-second-level">
            <li> <a href="/contacts"> <span class="fa fa-users"></span> Contacts </a> </li>
            <li> <a href="/commands"> <span class="fa fa-terminal"></span> Commands </a> </li>
            <li> <a href="/timeperiods"> <span class="fa fa-calendar"></span> Time periods </a> </li>
          </ul>
        </li>
        %other_uis = app.get_ui_external_links()
        %if len(other_uis) > 0:
        <li> <a href="#"><i class="fa fa-rocket"></i> External <i class="fa arrow"></i></a>
          <ul class="nav nav-second-level">
            %for c in other_uis:
            <li>
              <a href="{{c['uri']}}" target="_blank"><span class="fa fa-rocket"></span> {{c['label']}}</a>
            </li>
            %end
          </ul>
        </li>
        %end
        %end

      </ul>
    </div>
    <!-- /.sidebar-collapse -->
  </div>
  <!-- /.navbar-static-side -->
</nav>

<script type="text/javascript">
   // On page loaded ...
   $(function() {
      // Date / time
      $('.headClock .time').jclock({ format: '%H:%M:%S' });
      $('.headClock .date').jclock({ format: '%d/%m/%Y' });

      $('[data-toggle="popover"]').popover({
        html: true,
        template: '<div class="popover img-popover"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>',
      });
   });
</script>
