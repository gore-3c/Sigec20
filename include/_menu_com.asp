<div class="horizontal-main clearfix">
    <div class="horizontal-mainwrapper container clearfix">       
        <nav class="horizontalMenu clearfix">
            <ul class="horizontalMenu-list">
                <li aria-haspopup="true"><a href="../sce_commercial/index.asp" class=""> Accueil </a></li>
                <li aria-haspopup="true"><a href="#" class="sub-icon">Ajustements Poids <i class="fa fa-angle-down horizontal-icon"></i></a>
                    <ul class="sub-menu">
                        <%If Code = "95" Then%>
                        <li aria-haspopup="true"><a href="../sce_commercial/ajust_suivi.asp">Suivi</a></li>
                        <%End If%>
                        <li aria-haspopup="true"><a href="../sce_commercial/ajust_maj.asp">Mise à jour</a></li>
                        <li aria-haspopup="true"><a href="../sce_commercial/ajust_edition.asp">Edition</a></li>
                    </ul>
                </li>
                <%If Code="95" Or Code = "377" Or Code="867" Or Code="840" Or Code="871" Then%>
                <li aria-haspopup="true"><a href="fs_dash.asp" class="sub-icon"> Factures Soutien <i class="fa fa-angle-down horizontal-icon"></i></a>
                    <ul class="sub-menu">
                        <li aria-haspopup="true"><a href="../sce_commercial/fs_reception.asp">Réception</a></li>
                        <li aria-haspopup="true"><a href="../sce_commercial/fs_correction.asp">Correction</a></li>
                        <li aria-haspopup="true"><a href="../sce_commercial/fs_sup.asp">Suppression</a></li>
                        <li aria-haspopup="true"><a href="../sce_commercial/affiche_fo1.asp">Formule</a></li>
                    </ul>
                </li>
                <%End If%>
                <%If Code = "95" Or Code = "98" Or Code = "867" Or Code = "377" Or Code = "850" Then%>
                <li aria-haspopup="true"><a href="#" class="sub-icon"> Gestion <i class="fa fa-angle-down horizontal-icon"></i></a>
                    <ul class="sub-menu">
                        <li aria-haspopup="true"><a href="../sce_commercial/cv_cession.asp">Cession contrat</a></li>
                        <li aria-haspopup="true"><a href="../sce_commercial/transitaire_maj.asp">Transitaire</a></li>                        
                    </ul>
                </li>
                <%If Code = "95" Or Code = "377" Or Code = "867" Then%>
                <li aria-haspopup="true"><a href="#" class="sub-icon"> Fiscalités <i class="fa fa-angle-down horizontal-icon"></i></a>
                    <ul class="sub-menu">
                        <li aria-haspopup="true" class="sub-menu-sub"><a href="#">Hors Normes</a>
                            <ul class="sub-menu">
                                <li aria-haspopup="true"><a href="../sce_commercial/hn_redevances.asp">Redevances</a></li>
                            </ul>
                        </li>
                        <li aria-haspopup="true" class="sub-menu-sub"><a href="#">SIGEC4</a>
                            <ul class="sub-menu">
                                <li aria-haspopup="true" class="sub-menu-sub"><a href="#">Différentiel</a>
                                    <ul class="sub-menu">
                                        <li aria-haspopup="true"><a href="../sce_commercial/differentiel.asp">Différentiel</a></li>
                                        <li aria-haspopup="true"><a href="../sce_commercial/fiscalite.asp">Redevances</a></li>
                                    </ul>
                                </li>
                                <li aria-haspopup="true" class="sub-menu-sub"><a href="#">Différentiel Mixte</a>
                                    <ul class="sub-menu">
                                        <li aria-haspopup="true"><a href="../sce_commercial/redevances_mixtes.asp">Redevances</a></li>
                                        <li aria-haspopup="true"><a href="../sce_commercial/differentiel_mixte.asp">Différentiel </a></li>
                                    </ul>
                                </li>
                                <li aria-haspopup="true" class="sub-menu-sub"><a href="#">Suivi Contrats</a>
                                    <ul class="sub-menu">
                                        <li aria-haspopup="true"><a href="../sce_commercial/cv_deblocages_non_visible.asp">Déblocages non visible</a></li>
                                        <li aria-haspopup="true"><a href="../sce_commercial/cdc_non_visible_sigec4.asp">CV générés non visibles</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
                <%End If%>
                <li aria-haspopup="true"><a href="#" class="sub-icon"> Paramétrage <i class="fa fa-angle-down horizontal-icon"></i></a>
                    <ul class="sub-menu">
                        <li aria-haspopup="true" class="sub-menu-sub"><a href="#">Agrément</a>
                            <ul class="sub-menu">
                                <li aria-haspopup="true"><a href="../sce_commercial/exp_creation.asp">Nouveau</a></li>
                                <li aria-haspopup="true"><a href="../sce_commercial/exp_agrement.asp">Agrément</a></li>
                            </ul>
                        </li>
                        <li aria-haspopup="true" class="sub-menu-sub"><a href="#">Campagne</a>
                            <ul class="sub-menu">
                                <li aria-haspopup="true"><a href="../sce_commercial/campagne.asp">Campagne / Recolte</a></li>
                                <li aria-haspopup="true"><a href="../sce_commercial/periode.asp">Periodes</a></li>
                            </ul>
                        </li>
                    </ul>
                </li>
                <%End If%>
                <%If Code = "95" Or Code = "377" Or Code = "867" Then%>
                <li aria-haspopup="true"><a href="#" class="sub-icon"> Support <i class="fa fa-angle-down horizontal-icon"></i></a>
                    <ul class="sub-menu">
                        <li><a href="../all_user/cv_sans_soutien.asp">CV Sans Soutien</a></li>
                        <li><a href="../all_user/cv_sans_decote.asp">CV Sans Décote</a></li>
                        <li><a href="../all_user/cv_chgt_parite.asp">PRIX Changt Parité</a></li>
                        <li><a href="../sce_commercial/cv_prixcafemb_up.asp">Correction Prix CAF</a></li>
                        <%If Code = "95" Or Code = "77" Then%>
                        <li><a href="../sce_commercial/cv_cession.asp">Cession contrat</a></li>
                        <li><a href="../all_user/transfert_sygesap.asp">Tansfert SIGEC4-SYGESAP</a></li>
                        <li><a href="../all_user/dus_up.asp">Correction DUS</a></li>
                        <li><a href="../sce_technique/chq_doublon.asp">Cheques en doublon</a></li>
                        <%End If%>
                    </ul>
                </li>
                <%End If%>
                <li aria-haspopup="true"><a href="../out.asp" class=""><i class="fa fa-question-circle"></i> Déconnexion</a></li>
            </ul>
        </nav>
    </div>
</div>