<%@ include file="./inc/_taglibs.jsp" %>

<struct:htmlWrapper navi="dailyWork">

<jsp:attribute name="includeInHeader">
  <link rel="stylesheet" href="static/css/dailywork.css" type="text/css"/>
  
  <script type="text/javascript" src="static/js/excanvas.js"></script>
  <link rel="stylesheet" href="static/css/timeplot.css" type="text/css"/>
  <link rel="stylesheet" href="static/css/timeline/timeline.css" type="text/css"/>
  <link rel="stylesheet" href="static/css/timeline/ether.css" type="text/css"/>
  <link rel="stylesheet" href="static/css/timeline/event.css" type="text/css"/>
  <style type="text/css">
  .ui-tabs .ui-tabs-hide {
      position: absolute !important;
      left: -10000px !important;
      display: block !important;
  }
  </style>
  <script type="text/javascript" src="static/js/simile-widgets.js"></script>
  <script type="text/javascript" src="static/js/simile/extensions/LoadPlot.js"></script>
  <script type="text/javascript" src="static/js/simile/extensions/user-load-timeplot-source.js"></script>
  <script type="text/javascript" src="static/js/simile/extensions/UserLoadPlotWidget.js"></script>
  <script type="text/javascript" src="static/js/jquery.tagcloud.min.js"></script>
</jsp:attribute>

<jsp:body>

<!-- User selector -->
<ww:form method="get">
<h2>The daily work of <ww:select list="enabledUsers"
    listKey="id" listValue="fullName" name="userId" value="%{user.id}"
    onchange="this.form.submit();" /></h2>
</ww:form>

<%@ include file="./inc/_userLoad.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
  var controller = new DailyWorkController({
    userId:                   ${user.id},
    workQueueElement:         $('#work-queue'),
    assignedStoriesElement:   $('#story-list'),
    tasksWithoutStoryElement: $('#task-list'),
    emptyDailyWorkNoteBox:    $('#empty-note'),
    onUserLoadUpdate: function() { window.personalLoadController.updateLoadGraph(); }
  });
});
</script>

<div id="empty-note" class="warning-note" style="display: none;">
<strong>Note!</strong><br/>
You don't currently have any stories or tasks assigned to you.<br/>
Daily Work contains tasks and stories, which are in an <em>ongoing iteration</em>, and of which you are responsible.
<a href="#" style="font-size: 80%; color: #1e5eee; text-decoration: underline;" onclick="HelpUtils.openHelpPopup(this,'Daily Work','static/html/help/dailyWorkPopup.html'); return false;">What is Daily Work?</a>
</div>

<!-- Work queue -->
<form onsubmit="return false;"><div id="work-queue" class="structure-main-block"></div></form>

<!-- Assigned stories -->
<form onsubmit="return false;"><div id="story-list" class="structure-main-block"></div></form>

<!-- Tasks without story -->
<form onsubmit="return false;"><div id="task-list" class="structure-main-block"></div></form>

</jsp:body>

</struct:htmlWrapper>