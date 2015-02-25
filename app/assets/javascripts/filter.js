$("#filter_projects").on("click", function() {
      $("#filters").animate({width: "toggle"}, 1000);
    });

$(document).ready(function() {
  var auth_token = "<%= form_authenticity_token %>"

  var cleanFilters = function(filters) {
    var cleanedFilters = [];
    filters.forEach(function(element) {
      cleanedFilters.push(element.match(/\[(.*?)\]/)[1]);
    });
    return cleanedFilters;
  }

  var appendProject = function(project) {
    $("#projects").append(
      "<div class='col-md-3'><a href='/" + project.organization + "/projects/" + project.id + "'>" + project.title + "</a>" +
      "<a href='/" + project.organization + "/projects/" + project.id + "'><img src='" + project.image_url +
      "' width='250px' height='auto'></a>" + "<div class='project-desc'>" + project.description + "</div>" +
      '<form action="/pending_loan" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden"' +
      'value="&#x2713;" /><input type="hidden" name="authenticity_token" value="' + auth_token + '" />' +
      '<input value="' + project.id + '" type="hidden" name="pending_loan[project_id]" id="pending_loan_' + project.id + '" />' +
      '<input value="2500" type="hidden" name="pending_loan[loan_amount]" id="pending_loan_loan_amount" />' +
      '<input type="submit" name="commit" value="Lend $25" class="btn btn-default" /></form></div>'
    )
  }

  var appendProjects = function(projects) {
    projects.forEach(function(project) {
      appendProject(project);
    });
  };

  var renderProjects = function(filteredProjects) {
    $("#projects").empty();
    appendProjects(filteredProjects);
  };

  var filterProjectsByCategory = function(projects, checkedFilters) {
    return projects.filter(function(project) {
      return project.categories.some(function(category) {
        return checkedFilters.indexOf(category) > -1;
      });
    });
  };

  var filterProjects = function(projects, checkedFilters) {
    projectsFilteredByCategory = filterProjectsByCategory(projects, checkedFilters);
    //return filterProjectsByPrice(projectsFilteredByCategory, checkedFilters);
    return projectsFilteredByCategory;
  };

  var initialCategories = function() {
    var initial_category_selected = window.location.href.slice(window.location.href.indexOf('=') + 1);
    var initial_categories = [];
    initial_categories.push(initial_category_selected);
    return initial_categories;
  };

  var all_projects;

  $.getJSON("/projects.json", function(json_data) {
    all_projects = json_data;
    if ($("input:checked").length > 0) {
      var filteredProjects = filterProjects(all_projects, initialCategories());
    } else {
      var filteredProjects = all_projects;
    }
    renderProjects(filteredProjects);
  });

  $(":checkbox").on("click", function() {
    var filters = [];
    $("input:checked").each(function(index) {
      filters.push(this.name);
    });
    var cleanedFilters = cleanFilters(filters);
    var filteredProjects = filterProjects(all_projects, cleanedFilters);
    renderProjects(filteredProjects);
  });
});
