
function printMenu(parentId, data) {

  // This is the array that contains all the list items.
  //global data;

  // We start an unordered list.
  line = '<ul>';

  // We loop through each sub-array.
  foreach ($parent_element as $item_id => $list_item) {

    // We display the item.
    echo '<li>' . $list_item;

    // Now we have to check for sub-items.
    if (isset($items[$item_id])) {

      // If TRUE, then this function calls itself (recursive function)
      // in order to create the structure of the navigation menu.
      printMenu($items[$item_id]);

    }

    // We complete the list item.
    echo '</li>';

  } // End of foreach().

  // We close the unordered list.
  echo '</ul>';

}