<div class="app-header header d-flex">
    <div class="container">
        <div class="d-flex">
            <a class="header-brand" href="index.html">
                <img src="../assets/images/logo.jpg" class="header-brand-img" alt="SIGEC4 logo">
            </a><!-- logo-->
            <a id="horizontal-navtoggle" class="animated-arrow"><span></span></a><!-- sidebar-toggle-->
            <a href="#" data-toggle="search" class="nav-link nav-link d-md-none navsearch"><i class="fa fa-search"></i></a><!-- search icon -->
            <div class="dropdown d-none d-lg-block d-md-flex user">
                <a class="nav-link icon" data-toggle="dropdown">
                    <i class="fe fe-user"></i>
                    <span class="pulse bg-danger"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right dropdown-menu-arrow">
                    <a class="dropdown-item d-flex pb-3" href="#">
                        <span class="avatar brround mr-3 align-self-center cover-image" data-image-src="assets/images/faces/male/4.jpg"></span>
                        <div>
                            <strong>Madeleine Scott</strong> Sent you add request
                            <div class="small text-muted">
                                view profile
                            </div>
                        </div>
                    </a>
                    <a class="dropdown-item d-flex pb-3" href="#">
                        <span class="avatar brround mr-3 align-self-center cover-image" data-image-src="assets/images/faces/female/14.jpg"></span>
                        <div>
                            <strong>rebica</strong> Suggestions for you
                            <div class="small text-muted">
                                view profile
                            </div>
                        </div>
                    </a>
                    <a class="dropdown-item d-flex pb-3" href="#">
                        <span class="avatar brround mr-3 align-self-center cover-image" data-image-src="assets/images/faces/male/1.jpg"></span>
                        <div>
                            <strong>Devid robott</strong> sent you add request
                            <div class="small text-muted">
                                view profile
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-divider"></div><a class="dropdown-item text-center text-muted-dark" href="#">View all contact list</a>
                </div>
            </div><!-- user-icon -->
            <div class="dropdown d-none d-lg-block">
                <a class="nav-link icon" data-toggle="dropdown" aria-expanded="false">
                    <i class="fe fe-bell "></i>
                    <span class="pulse bg-danger"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right dropdown-menu-arrow">
                    <a href="#" class="dropdown-item text-center">3 New Notifications</a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item d-flex pb-3">
                        <div class="notifyimg bg-green">
                            <i class="fa fa-thumbs-o-up "></i>
                        </div>
                        <div>
                            <strong>Someone likes our posts.</strong>
                            <div class="small text-muted">3 hours ago</div>
                        </div>
                    </a>
                    <a href="#" class="dropdown-item d-flex pb-3">
                        <div class="notifyimg bg-blue">
                            <i class="fa fa-commenting-o"></i>
                        </div>
                        <div>
                            <strong> 3 New Comments</strong>
                            <div class="small text-muted">5  hour ago</div>
                        </div>
                    </a>
                    <a href="#" class="dropdown-item d-flex pb-3">
                        <div class="notifyimg bg-orange">
                            <i class="fa fa-eye"></i>
                        </div>
                        <div>
                            <strong> 10 views</strong>
                            <div class="small text-muted">2  hour ago</div>
                        </div>
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item text-center">View all Notifications</a>
                </div>
            </div><!-- notifications -->
            <div class="dropdown d-none d-md-flex">
                <a  class="nav-link icon full-screen-link">
                    <i class="fe fe-maximize-2"  id="fullscreen-button"></i>
                </a>
            </div><!-- full-screen -->
            <div class="d-flex order-lg-2 ml-auto horizontal-dropdown">							
                <div class="dropdown dropdown-toggle">
                    <a href="#" class="nav-link leading-none" data-toggle="dropdown">
                        <span class="avatar avatar-md brround"><img src="../assets/images/faces/male/33.jpg" alt="Profile-img" class="avatar avatar-md brround"></span>
                        <span class="mr-3 d-none d-lg-block ">
                            <span class="text-gray-white"><span class="ml-2"><%=Session("Nom")%></span></span>
                        </span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right dropdown-menu-arrow">
                        <div class="text-center">
                            <a href="#" class="dropdown-item text-center font-weight-sembold user"><%=Session("Nom")%></a>
                            <div class="dropdown-divider"></div>
                        </div>
                        <a class="dropdown-item" href="#">
                            <i class="dropdown-icon mdi mdi-account-outline "></i> Profile
                        </a>
                        <a class="dropdown-item" href="#">
                            <i class="dropdown-icon  mdi mdi-settings"></i> Settings
                        </a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="../out.asp">
                            <i class="dropdown-icon mdi  mdi-logout-variant"></i> Deconnexion
                        </a>
                    </div>
                </div><!-- profile -->
            </div>
        </div>
    </div>
</div>