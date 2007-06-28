<%@ include file="./inc/_taglibs.jsp" %>
<%@ include file="./inc/_header.jsp" %>
<aef:bct backlogId="${backlogId}"/>

<aef:menu navi="${contextName}" pageHierarchy="${pageHierarchy}"/> 
	<ww:actionerror/>
	<ww:actionmessage/>
	<h2>Edit backlog item</h2>
	
	<ww:form action="storeBacklogItem">
		
		<ww:hidden name="backlogItemId" value="${backlogItem.id}"/>
		<aef:userList/>
		<aef:currentUser/>
  	<aef:iterationGoalList id="iterationGoals" backlogId="${backlogId}"/>
  	<aef:productList/>

		<table class="formTable">
		<tr>
		<td></td>
		<td></td>
		<td></td>	
		</tr>

		<tr>
		<td>Name</td>
		<td>*</td>
		<td><ww:textfield size="60" name="backlogItem.name"/></td>	
		</tr>
		
		<tr>
		<td>Description</td>
		<td></td>
		<td><ww:textarea cols="70" rows="10" name="backlogItem.description"/></td>	
		</tr>
		
		<tr>
		<td>Effort estimate</td>
		<td></td>
		<td><ww:textfield size="10" name="backlogItem.allocatedEffort"/>(usage: *h *m, e.g. 3h) </td>	
		</tr>
			
		<tr>
		<td>Backlog</td>
		<td></td>
		<td>
		<select name="backlogId">	
		
			<%-- logId = backlogItem.backlog.id if editing page
					 logId = backlogId if creating a new backlog item  --%>
			<c:choose>
				<c:when test="${!empty backlogItem.backlog}">
					<c:set var="logId" value="${backlogItem.backlog.id}" scope="page"/>	
				</c:when>
				<c:otherwise>
					<c:set var="logId" value="${backlogId}" scope="page"/>
				</c:otherwise>
			</c:choose>	
			
			<%-- Generate a drop-down list showing all backlogs in a hierarchical manner --%>
			<c:forEach items="${productList}" var="product">
				<c:choose>
					<c:when test="${product.id == logId}">
						<option selected="selected" value="${product.id}" title="${product.name}">${aef:out(product.name)}</option>
					</c:when>
					<c:otherwise>
						<option value="${product.id}" title="${product.name}">${aef:out(product.name)}</option>
					</c:otherwise>
				</c:choose>
				<c:forEach items="${product.deliverables}" var="deliverable">
					<c:choose>
						<c:when test="${deliverable.id == logId}">
							<option selected="selected" value="${deliverable.id}" title="${deliverable.name}">&nbsp;&nbsp;&nbsp;&nbsp;${aef:out(deliverable.name)}</option>
						</c:when>
						<c:otherwise>
							<option value="${deliverable.id}" title="${deliverable.name}">&nbsp;&nbsp;&nbsp;&nbsp;${aef:out(deliverable.name)}</option>
						</c:otherwise>
					</c:choose>
					<c:forEach items="${deliverable.iterations}" var="iteration">
						<c:choose>
							<c:when test="${iteration.id == logId}">
								<option selected="selected" value="${iteration.id}" title="${iteration.name}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${aef:out(iteration.name)}</option>
							</c:when>
							<c:otherwise>
								<option value="${iteration.id}" title="${iteration.name}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${aef:out(iteration.name)}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:forEach>						
			</c:forEach>				
		</select>
		</td>
		</tr>
		
		<tr>
		<td>Link to iteration goal</td>
		<td></td>	
		
		<%-- If iteration goals doesn't exist default value is 0--%>
		<c:choose>
		<c:when test="${!empty iterationGoals}">
			<c:set var="goalId" value="0" scope="page"/>
			<c:if test="${!empty backlogItem.iterationGoal}">
				<c:set var="goalId" value="${backlogItem.iterationGoal.id}" scope="page"/>
			</c:if>
			<td><ww:select headerKey="0" headerValue="(none)" name="backlogItem.iterationGoal.id" list="#attr.iterationGoals" listKey="id" listValue="name" value="${goalId}"/></td>
		</c:when>
		<c:otherwise>
			<td>(none)</td>
		</c:otherwise>
		</c:choose>
		</tr>
		
		<tr>
		<td>Priority</td>
		<td></td>
		<td><ww:select name="backlogItem.priority" value="backlogItem.priority.name" list="@fi.hut.soberit.agilefant.model.Priority@values()" listKey="name" listValue="getText('backlogItem.priority.' + name())"/></td>	
		</tr>
		
		<tr>
		<td>Responsible</td>
		<td></td>
		<c:choose>
		<c:when test="${backlogItem.id == 0}">
			<td><ww:select headerKey="0" headerValue="(none)" name="assigneeId" list="#attr.userList" listKey="id" listValue="fullName" value="0"/></td>	
		</c:when>
		<c:otherwise>
			<td><ww:select headerKey="0" headerValue="(none)" name="assigneeId" list="#attr.userList" listKey="id" listValue="fullName" value="%{backlogItem.assignee.id}"/></td>	
		</c:otherwise>
		</c:choose>
		</tr>
		
		<tr>
		<td>Watch this item</td>
		<td></td>
		
		<%-- BacklogItemAction.store() sets the watch-field to false unless this checkbox is checked --%>
		<c:choose>
		<%-- When creating a backlog item watching is off by default--%>
		<c:when test="${backlogItem.id == 0}">
			<td><ww:checkbox name="watch" value="false" fieldValue="true"/></td>	
		</c:when>
		<c:otherwise>
			<td><ww:checkbox name="watch" value="${!empty backlogItem.watchers[currentUser.id]}" fieldValue="true"/></td>	
		</c:otherwise>
		</c:choose>
		</tr>
		
		
		<tr>
		<td></td>
		<td></td>
		<td>
		<ww:submit value="Store"/>
    <ww:submit name="action:popContext" value="Back"/> 
		</td>	
		</tr>
		
		</table>

	</ww:form>
	
	<c:if test="${backlogItem.id > 0}">
		<aef:currentUser/>

	<table>
	<tr><td>

		<div id="subItems">
		<div id="subItemHeader">
			Tasks 
			<ww:url id="createLink" action="createTask" includeParams="none">
				<ww:param name="backlogItemId" value="${backlogItemId}"/>
			</ww:url>
			<ww:a href="%{createLink}&contextViewName=editBacklogItem&contextObjectId=${backlogItemId}">Create new &raquo;</ww:a>
		</div>
		<div id="subItemContent">
		<p>
			<display:table class="listTable" name="backlogItem.tasks" id="row" requestURI="editBacklogItem.action">
				<display:column sortable="true" title="Name">
					<ww:url id="editLink" action="editTask" includeParams="none">
						<ww:param name="taskId" value="${row.id}"/>
					</ww:url>
					<ww:a href="%{editLink}&contextViewName=editBacklogItem&contextObjectId=${backlogItemId}">
						${aef:html(row.name)}
					</ww:a>
				</display:column>
				<display:column sortable="true" title="Effort left" sortProperty="effortEstimate.time">
					${row.effortEstimate}
				</display:column>
				<display:column sortable="true" title="Work performed" sortProperty="performedEffort.time">
					${row.performedEffort}
				</display:column>
				<display:column sortable="true" title="Priority" sortProperty="priority.ordinal">
					<ww:text name="task.priority.${row.priority}"/>
				</display:column>
				<display:column sortable="true" title="Status" sortProperty="status.ordinal">
					<ww:text name="task.status.${row.status}"/>
				</display:column>
				<display:column sortable="true" title="Created">
					<ww:date name="#attr.row.created" />
				</display:column>
				<display:column sortable="true" title="Responsible">
					${aef:html(row.assignee.fullName)}
				</display:column>
				<display:column sortable="true" title="Creator">
					${aef:html(row.creator.fullName)}
				</display:column>
				<display:column sortable="false" title="Actions">
					<!-- <ww:url id="editLink" action="editTask" includeParams="none">
						<ww:param name="taskId" value="${row.id}"/>
					</ww:url> -->
					<ww:url id="deleteLink" action="deleteTask" includeParams="none">
						<ww:param name="taskId" value="${row.id}"/>
					</ww:url>
					<!-- <ww:a href="%{editLink}&contextViewName=editBacklogItem&contextObjectId=${backlogItemId}">Edit</ww:a>|-->
					<ww:a href="%{deleteLink}&contextViewName=editBacklogItem&contextObjectId=${backlogItemId}" onclick="return confirmDeleteTask()">Delete</ww:a>
				</display:column>
			</display:table>
		</p>
	
		</div>
		</div>
</td></tr></table>
		
	</c:if>	

<%@ include file="./inc/_footer.jsp" %>
