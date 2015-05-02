%rebase layout globals(), css=['groups/css/groups-overview.css'], js=['groups/js/groups-overview.js'], title='Hosts groups overview', refresh=True

%helper = app.helper

%from shinken.misc.filter import only_related_to

%nHosts=0
%hosts=app.get_hosts(user)
%hUp=hDown=hUnreachable=hPending=hUnknown=0
%pctUp=pctDown=pctUnreachable=pctPending=pctUnknown=0
%for h in hosts:
   %nHosts=nHosts+1
   %if h.state == 'UP':
      %hUp=hUp+1
   %elif h.state == 'DOWN':
      %hDown=hDown+1
   %elif h.state == 'UNREACHABLE':
      %hUnreachable=hUnreachable+1
   %elif h.state == 'PENDING':
      %hPending=hPending+1
   %else:
      %hUnknown=hUnknown+1
   %end
%end
%if nHosts != 0:
   %pctUp            = round(100.0 * hUp / nHosts, 2)
   %pctDown          = round(100.0 * hDown / nHosts, 2)
   %pctUnreachable   = round(100.0 * hUnreachable / nHosts, 2)
   %pctPending       = round(100.0 * hPending / nHosts, 2)
   %pctUnknown       = round(100.0 * hUnknown / nHosts, 2)
%end

<div class="row">
  <div class="pull-left col-sm-2">
    <span class="pull-right">Total hosts: {{len(hosts)}}</span>
  </div>
  <div class="pull-left progress col-sm-8 no-leftpadding no-rightpadding" style="height: 25px;">
    <div title="{{hUp}} hosts Up" class="progress-bar progress-bar-success quickinfo" role="progressbar" 
      data-toggle="tooltip" data-placement="bottom" 
      style="line-height: 25px; width: {{pctUp}}%;">{{pctUp}}% Up</div>
      
    <div title="{{hDown}} hosts Down" class="progress-bar progress-bar-danger quickinfo" 
      data-toggle="tooltip" data-placement="bottom" 
      style="line-height: 25px; width: {{pctDown}}%;">{{pctDown}}% Down</div>
      
    <div title="{{hUnreachable}} hosts Unreachable" class="progress-bar progress-bar-warning quickinfo" 
      data-toggle="tooltip" data-placement="bottom" 
      style="line-height: 25px; width: {{pctUnreachable}}%;">{{pctUnreachable}}% Unreachable</div>
      
    <div title="{{hPending}} hosts Pending" class="progress-bar progress-bar-info quickinfo" 
      data-toggle="tooltip" data-placement="bottom" 
      style="line-height: 25px; width: {{pctPending}}%;">{{pctPending}}% Pending</div>
      
    <div title="{{hPending}} hosts Pending/Unknown" class="progress-bar progress-bar-info quickinfo" 
      data-toggle="tooltip" data-placement="bottom" 
      style="line-height: 25px; width: {{pctPending}}%;">{{pctUnknown}}% Unknown</div>
  </div>
  <div class="pull-right col-sm-2">
    <span class="btn-group pull-right">
      <a href="#" id="listview" class="btn btn-small switcher pull-right" data-original-title='List'> <i class="fa fa-align-justify"></i> </a>
      <a href="#" id="gridview" class="btn btn-small switcher active pull-right" data-original-title='Grid'> <i class="fa fa-th"></i> </a>
    </span>
  </div>
</div>

<div class="row">
  <ul id="groups" class="grid row">
    %even='alt'
    %nGroups=0
    %nHosts=0
    %hUp=0
    %hDown=0
    %hUnreachable=0
    %hPending=0 # Pending / unknown
    %for h in hosts:
      %nHosts=nHosts+1
      %if h.state == 'UP':
        %hUp=hUp+1
      %elif h.state == 'DOWN':
        %hDown=hDown+1
      %elif h.state == 'UNREACHABLE':
        %hUnreachable=hUnreachable+1
      %else:
        %hPending=hPending+1
      %end
    %end
    %nGroups=len(hostgroups)
    <li class="clearfix {{even}}">
      <section class="left">
        <h3>All hosts</h3>
        <span class="meta">
         <span class="{{'font-up' if hUp > 0 else 'font-greyed'}}">
            <span class="fa-stack"><i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-check fa-stack-1x fa-inverse"></i></span> 
            <span class="num">{{hUp}}</span>
         </span> 
          
         <span class="{{'font-unreachable' if hUnreachable > 0 else 'font-greyed'}}">
            <span class="fa-stack"> <i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-exclamation fa-stack-1x fa-inverse"></i></span> 
            <span class="num">{{hUnreachable}}</span>
         </span> 

         <span class="{{'font-down' if hDown > 0 else 'font-greyed'}}">
            <span class="fa-stack"> <i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-arrow-down fa-stack-1x fa-inverse"></i></span> 
            <span class="num">{{hDown}}</span>
         </span> 

         <span class="{{'font-pending' if hPending > 0 else 'font-greyed'}}">
            <span class="fa-stack"> <i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-question fa-stack-1x fa-inverse"></i></span> 
            <span class="num">{{hPending}}</span>
         </span> 
        </span>
        <!--
        <span class="meta"> <span class="label label-important pulsate">Business impact</span> </span>
        -->
      </section>
      
      <section class="right">
        <div class="pull-right">
          <span class="sumHosts">{{'%d host' % nHosts if nHosts == 1 else '%d hosts' % nHosts}}</span>
          <span class="sumGroups">{{'%d group' % nGroups if nGroups == 1 else '' if nGroups == 0 else '%d groups' % nGroups}}</span>
        </div>
        <span class="darkview">
          <a href="/hosts-group/all" class="firstbtn"><i class="fa fa-angle-double-down"></i> Details</a>
          <br/>
          <a href="/minemap/all" class="firstbtn"><i class="fa fa-table"></i> Minemap</a>
        </span>
      </section>
    </li>

    %even='alt'
    %for group in hostgroups:
      %if even =='':
        %even='alt'
      %else:
        %even=''
      %end

      %nGroups=0
      %nHosts=0
      %hosts=only_related_to(group.get_hosts(),user)
      %hUp=0
      %hDown=0
      %hUnreachable=0
      %hPending=0
      %business_impact = 0
      %for h in hosts:
        %business_impact = max(business_impact, h.business_impact)
        %nHosts=nHosts+1
        %if h.state == 'UP':
          %hUp=hUp+1
        %elif h.state == 'DOWN':
          %hDown=hDown+1
        %elif h.state == 'UNREACHABLE':
          %hUnreachable=hUnreachable+1
        %else:
          %hPending=hPending+1
        %end
      %end
      
      %nGroups=len(group.get_hostgroup_members())
      <!-- <li>{{group.get_name()}} - {{nHosts}} - {{nGroups}} - {{group.get_hostgroup_members()}}</li> -->
      %if nHosts > 0 or nGroups > 0:
        
        <li class="clearfix {{even}} {{'alert' if nHosts == hDown else ''}}">
          <section class="left">
            <h3>{{group.alias if group.alias != '' else group.get_name()}}
              %for i in range(0, business_impact-2):
              <img alt="icon state" src="/static/images/star.png">
              %end
              %if hasattr(group, 'customs') and len(group.customs) > 0:
                %if hasattr(group.customs, '_GROUP_LEVEL') > 0:
                  - level {{group.customs['_GROUP_LEVEL']}}
                %end
              %end
              %if group.has('hostgroup_members'):
                %for g in sorted(group.get_hostgroup_members()):
                    <span>{{g.get_name()}}</span>
                %end
              %end
            </h3>
              <span class="meta">
               <span class="{{'font-up' if hUp > 0 else 'font-greyed'}}">
                  <span class="fa-stack"><i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-check fa-stack-1x fa-inverse"></i></span> 
                  <span class="num">{{hUp}}</span>
               </span> 
                
               <span class="{{'font-unreachable' if hUnreachable > 0 else 'font-greyed'}}">
                  <span class="fa-stack"> <i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-exclamation fa-stack-1x fa-inverse"></i></span> 
                  <span class="num">{{hUnreachable}}</span>
               </span> 

               <span class="{{'font-down' if hDown > 0 else 'font-greyed'}}">
                  <span class="fa-stack"> <i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-arrow-down fa-stack-1x fa-inverse"></i></span> 
                  <span class="num">{{hDown}}</span>
               </span> 

               <span class="{{'font-pending' if hPending > 0 else 'font-greyed'}}">
                  <span class="fa-stack"> <i class="fa fa-circle fa-stack-2x"></i> <i class="fa fa-question fa-stack-1x fa-inverse"></i></span> 
                  <span class="num">{{hPending}}</span>
               </span> 
              </span>
          </section>
          
          <section class="right">
            <div class="pull-right">
              <span class="sumHosts">{{'%d host' % nHosts if nHosts == 1 else '%d hosts' % nHosts}}</span>
              <span class="sumGroups">{{'%d group' % nGroups if nGroups == 1 else '' if nGroups == 0 else '%d groups' % nGroups}}</span>
            </div>
            <span class="darkview">
              <a href="/hosts-group/{{group.get_name()}}" class="firstbtn"><i class="fa fa-angle-double-down"></i> Details</a>
              <br/>
              <a href="/minemap/{{group.get_name()}}" class="firstbtn"><i class="fa fa-table"></i> Minemap</a>
            </span>
          </section>
        </li>
      %end
    %end
  </ul>
</div>