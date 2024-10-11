// recursive function to create multilevel menu list, parentId 0 is the Root
// function addapted from: http://crisp.tweakblogs.net/blog/317/formatting-a-multi-level-menu-using-only-one-query.html
function multilevelMenu(parentId, ctgLists, ctgData) {
  var html = '';       // stores and returns the html code with Menu lists

  // if parent item with child IDs in ctgLists
  if(ctgLists[parentId]) {
    html = '<ul>';      // open UL

    // traverses the array with child IDs of current parent, and adds them in LI tags, with their data from ctgData
    for (childId in ctgLists[parentId]) {
      // define CSS class in anchors, useful to be used in CSS style to design the menu
      if(parentId == 0) var clsa = ' class="firsrli"';       // to add class to anchors in main /first categories
      else if(ctgLists[ctgLists[parentId][childId]]) var clsa = ' class="litems"';       // to add class to anchors in lists with childs
      else var clsa = '';

      // open LI
      html += '<li><a href="'+ ctgData[ctgLists[parentId][childId]].lurl +'" title="'+ ctgData[ctgLists[parentId][childId]].lname +'"'+ clsa +'>'+ ctgData[ctgLists[parentId][childId]].lname +'</a>';

      html += multilevelMenu(ctgLists[parentId][childId], ctgLists, ctgData);     // re-calls the function to find parent with child-items recursively

      html += '</li>';      // close LI
    }
    html += '</ul>';       // close UL
  }

  return html;
}