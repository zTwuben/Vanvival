--[[
 _____  _    _  _   _ ______  _____  _   _      _    _   ___   _____      _   _  _____ ______  _____ 
|_   _|| |  | || | | || ___ \|  ___|| \ | |    | |  | | / _ \ /  ___|    | | | ||  ___|| ___ \|  ___|
  | |  | |  | || | | || |_/ /| |__  |  \| |    | |  | |/ /_\ \\ `--.     | |_| || |__  | |_/ /| |__  
  | |  | |/\| || | | || ___ \|  __| | . ` |    | |/\| ||  _  | `--. \    |  _  ||  __| |    / |  __| 
  | |  \  /\  /| |_| || |_/ /| |___ | |\  |    \  /\  /| | | |/\__/ /    | | | || |___ | |\ \ | |___ 
  \_/   \/  \/  \___/ \____/ \____/ \_| \_/     \/  \/ \_| |_/\____/     \_| |_/\____/ \_| \_|\____/ 
                                                                                                     
         				Thanks Mickey Knox for remaking the Project RV Interior mod
						Thanks Bucho Jefe & thepelona for making the RV Life mod                                                                                            
--]]


	--//Vehicles//--

local vehicles_list = {
	
	vehicles = {

		vanilla = {
	    vans = {
	        "Base.Van",
	        "Base.VanRadio",
	        "Base.VanRadio_3N",
	        "Base.VanBrewsterHarbin",
	        "Base.Van_BugWipers",
	        "Base.VanBuilder",
	        "Base.VanCarpenter",
	        "Base.VanCoastToCoast",
	        "Base.VanBeckmans",
	        "Base.VanFossoil",
	        "Base.VanGreenes",
	        "Base.VanOvoFarm",
	        "Base.Van_Blacksmith",
	        "Base.Van_Charlemange_Beer",
	        "Base.Van_CraftSupplies",
	        "Base.Van_Glass",
	        "Base.Van_HeritageTailors",
	        "Base.Van_Leather",
	        "Base.Van_Locksmith",
	        "Base.Van_Masonry",
	        "Base.Van_Perfick_Potato",
	        "Base.VanGardenGods",
	        "Base.VanGardener",
	        "Base.VanJohnMcCoy",
	        "Base.VanJonesFabrication",
	        "Base.VanKerrHomes",
	        "Base.VanKnobCreekGas",
	        "Base.Van_KnoxDisti",
	        "Base.VanKnoxCom",
	        "Base.VanKorshunovs",
	        "Base.Van_LectroMax",
	        "Base.VanLouisvilleLandscaping",
	        "Base.Van_MassGenFac",
	        "Base.VanMccoy",
	        "Base.VanMechanic",
	        "Base.VanMeltingPointMetal",
	        "Base.VanMetalheads",
	        "Base.VanMetalworker",
	        "Base.VanMicheles",
	        "Base.VanMobileMechanics",
	        "Base.VanMooreMechanics",
	        "Base.VanOldMill",
	        "Base.VanPennSHam",
	        "Base.VanPlattAuto",
	        "Base.VanPluggedInElectrics",
	        "Base.VanRiversideFabrication",
	        "Base.VanRosewoodworking",
	        "Base.VanSchwabSheetMetal",
	        "Base.VanSpiffo",
	        "Base.Van_Transit",
	        "Base.VanTreyBaines",
	        "Base.VanUncloggers",
	        "Base.VanUtility",
	        "Base.Van_VoltMojo",
	        "Base.VanWPCarpentry",
	        "Base.VanSeats_Space",
	        "Base.VanSeats_LadyDelighter",
	        "Base.VanSeats_Trippy",
	        "Base.VanSeats_Valkyrie",
			"Base.VanDeerValley",
	    },

	    stepVans = {
	        "Base.StepVan",
	        "Base.StepVanAirportCatering",
	        "Base.StepVanMail",
	        "Base.StepVan_Blacksmith",
	        "Base.StepVan_Butchers",
	        "Base.StepVan_Cereal",
	        "Base.StepVan_Citr8",
	        "Base.StepVan_Florist",
	        "Base.StepVan_Genuine_Beer",
	        "Base.StepVan_Glass",
	        "Base.StepVan_LouisvilleSWAT",
	        "Base.StepVan_Masonry",
	        "Base.StepVan_MobileLibrary",
	        "Base.StepVan_SmartKut",
	        "Base.StepVan_CompleteRepairShop",
	        "Base.StepVan_HuangsLaundry",
	        "Base.StepVan_Jorgensen",
	        "Base.StepVan_Heralds",
	        "Base.StepVan_LouisvilleMotorShop",
	        "Base.StepVan_MarineBites",
	        "Base.StepVan_Mechanic",
	        "Base.StepVan_Plonkies",
	        "Base.StepVan_RandisPlants",
	        "Base.StepVan_Scarlet",
	        "Base.StepVan_SouthEasternHosp",
	        "Base.StepVan_SouthEasternPaint",
	        "Base.StepVan_USL",
	        "Base.StepVan_Zippee",
	    },

	    camperRVs = {
	    },

	    bigRVs = {
	    },

	    boxTrucks = {
	    },

	    buses = {
	    },

	    utility = {
	        "Base.VanAmbulance",
	        "Base.VanMail",
	    },

		semiTrucks = {
		},
		},

		mods = {
			["86chevyCUCV"] = {
				vehicles = {
				    vans = {
				        "Base.86chevyM1010",
				        "Base.86chevyM1031",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},
				rvSupport = "both"
			},

			["87fordB700"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				        "Base.87fordF700bank",
				        "Base.87fordF700swat",
				    },

				    buses = {
				        "Base.87fordB700military",
				        "Base.87fordB700prison",
				        "Base.87fordB700school",						
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},
				rvSupport = "both"
			},

			["63Type2Van"] = {
				vehicles = {
				    vans = {
				        "Base.63Type2Van",
				        "Base.63Type2VanHippie",
				        "Base.63Type2VanApocalypse",
				        "Base.63Type2VanMilitary",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},
				rvSupport = "both"		

			},

			["FRUsedCarsAlpha"] = {
				vehicles = {
				    vans = {
				        "Base.fr_ch_astro_92",
				        "Base.fr_do_ram_90_moving",
				        "Base.fr_fo_econoline_86",
				        "Base.fr_fo_econoline_86_florist",
				    },

				    stepVans = {
				        "Base.fr_ch_stepvan_80",
				        "Base.fr_ch_stepvan_80_police",
				    },

				    camperRVs = {
				        "Base.fr_fo_econoline_rv_86",
				    },

				    bigRVs = {
				        "Base.fr_fl_bounder_86",
				    },

				    boxTrucks = {
				        "Base.fr_fo_f700_90_boxlarge",
				        "Base.fr_fo_f700_90_boxmed",
				        "Base.fr_is_nrr_93_boxmed",
				        "Base.fr_fo_b700_prisonlong",
				        "Base.fr_fo_b700_schoollong",
				        "Base.fr_fo_b700_schoolshort",
				    },

				    buses = {
				        "Base.fr_gm_newlook_70_35foot",
				    },

				    utility = {
				        "Base.fr_fo_econoline_86_ambulance",
				        "Base.fr_fo_f350_ambulance_80",
				        "Base.fr_gr_llv_89",
				        "Base.fr_pi_engine_90_fire",
				    },

					semiTrucks = {
					},
				},		
				rvSupport = "both"
			},

			["filisbustertrucksliveriesas24"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				        "Base.f700boxArmysurplus",
				        "Base.f700boxLGElouisvilleelectric",
				        "Base.f700boxShinrapilas",
				        "Base.f700boxTisconstruction",
				        "Base.f700boxVHSTRUCKas",
				        "Base.f700boxVKYFOODSas",
				        "Base.f700boxbombsquadLG",
				        "Base.f700boxenergypilas",
				        "Base.f700boxlouisvillelogistics",
				        "Base.f700boxnaranjita",
				        "Base.f700boxshellFedEXas",
				        "Base.f700boxshellSYSCOas",
				        "Base.f700boxshellUPSas",
				        "Base.f700boxshellautozoneas",
				        "Base.f700boxshellbestbuyas",
				        "Base.f700boxsouthpetrol",
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["PzkVanillaPlusCarPack"] = {
				vehicles = {
				    vans = {
				        "Base.pzkContinentalGuardian",
				        "Base.pzkContinentalGuardianLlama",
				        "Base.pzkDashVan70",
				        "Base.pzkDashVan70Riddle",
				        "Base.pzkFranklinBankTruck",
				        "Base.pzkFranklinTruckGarbage",
				        "Base.pzkFranklinVan70",
				        "Base.pzkVanGigamart",
				        "Base.pzkVanMcCoy",
				        "Base.pzkVanMultivan",
				        "Base.pzkVanMultivanPayday",
				        "Base.pzkVanSeatsTaxi",
				        "Base.pzkVanZSquad",
				        "Base.pzkMinivan2",
				        "Base.pzkMinivanC22",
				        "Base.pzkMinivanChev",
				        "Base.pzkMinivanConvoy",
				        "Base.pzkMinivanMPV",
				        "Base.pzkMinivanPrev",
				        "Base.pzkMinivanStellaris",
				        "Base.pzkMinivanStellarisTaxi",
				        "Base.pzkMinivanT3",
				        "Base.pzkMinivanT3C",
				        "Base.pzkMinivanTask",
			        	"Base.pzkChevalierVan70",						
				    },

				    stepVans = {
				        "Base.pzkStepVanFedLog",
				        "Base.pzkStepVanHotDog",
				        "Base.pzkStepVanIceCream",
				        "Base.pzkStepVanMilk",
				        "Base.pzkStepVanPizza",
				        "Base.pzkStepVanTacoVan",
				        "Base.pzkStepVanUPZ",
				    },

				    camperRVs = {
				        "Base.pzkContinentalGuardianService",
				        "Base.pzkVanCamper",
				        "Base.pzkFranklinTruckRV",
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				        "Base.pzkF350BoxAmbulance",
				        "Base.pzkF350BoxCUCV",
				        "Base.pzkF350BoxSwat",
				        "Base.pzkF350BoxUmoveit",
				        "Base.pzkVanBox",
				        "Base.pzkVanBoxAmbulance",
				        "Base.pzkVanBoxFiretruck",
				        "Base.pzkVanBoxSwat",
				        "Base.pzkFranklinTruckBox",
				        "Base.pzkFranklinTruckBoxLectromax",
				    },

				    buses = {
				        "Base.pzkFranklinTruckBus",
				        "Base.pzkFranklinTruckBusAirport",
				        "Base.pzkFranklinTruckBusArmy",
				        "Base.pzkFranklinTruckBusPrison",
				        "Base.pzkTransitBus",
				    },

				    utility = {
				        "Base.pzkVanPoliceWestPoint",
				        "Base.pzkVanilaVanAmbulance",
				        "Base.pzkFireTruckFlatLadder",
				        "Base.pzkFireTruckFlatPumper",
				        "Base.pzkFranklinTruckFire",
				        "Base.pzkMinivanStellarisMail",
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["73Winnebago"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				        "Base.73Winnebago",
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["ATA_Bus"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				        "Base.ATAArmyBus",
				        "Base.ATAPrisonBus",
				        "Base.ATASchoolBus",
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["pzkJesterVan"] = {
				vehicles = {
				    vans = {
				        "Base.VanJester",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["ATA_VanDeRumba"] = {
				vehicles = {
				    vans = {
				        "Base.ATA_VanDeRumba",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["86fordE150"] = {
				vehicles = {
				    vans = {
				        "86fordE150",
				        "86fordE150long",
				        "86fordE150slide",
				        "86fordE150slideSpiffo",
				        "86fordE150so",
				        "86fordE150ksp",
				        "86fordE150med",
				        "86fordE150mccoy",
				        "86fordE150longW",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["86fordE150dnd"] = {
				vehicles = {
				    vans = {
				        "86fordE150dnd",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},						
				rvSupport = "both"
			},

			["86fordE150expanded"] = {
				vehicles = {
				    vans = {
				        "86fordE150LVairportShuttle",
				        "86fordE150postal",
				        "86fordE150LBMWradio",
				        "86fordE150fossoil",
				        "86fordE150massGenfac",
				        "86fordE150kyTransit",
				        "86fordE150lectromax",
				        "86fordE150knoxDistilery",
				        "86fordE150ccconstruction",
				        "86fordE150beckmansBuilding",
				        "86fordE150kerrHomes",
				        "86fordE150rosewoodWorking",
				        "86fordE150lvLandscaping",
				        "86fordE150treyBaines",
				        "86fordE150mobileMechanics",
				        "86fordE150brewster",
				        "86fordE150mooresMechanics",
				        "86fordE150plattAutoRepair",
				        "86fordE150meltingPointMetal",
				        "86fordE150jones",
				        "86fordE150riversideFab",
				        "86fordE150schwab",
				        "86fordE150knoxTelecom",
				        "86fordE150knobCreek",
				        "86fordE150oldMillWaterCompany",
				        "86fordE150locksmith",
				        "86fordE150pluggedInElectrics",
				        "86fordE150voltMojo",
				        "86fordE150blacksmith",
				        "86fordE150zenith",
				        "86fordE150greenes",
				        "86fordE150oVoFarms",
				        "86fordE150perfick",
				        "86fordE150heritageTailors",
				        "86fordE150tasteTheBrew",
				        "86fordE150stoneworksMasonry",
				        "86fordE150leatherwork",
				        "86fordE150uncloggers",
				        "86fordE150bugWipers",
				        "86fordE150brushAndClay",
				        "86fordE150deerValley",						
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},					
				rvSupport = "both"
			},

			["86fordE150mm"] = {
				vehicles = {
				    vans = {
				        "86fordE150mm",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},
				},		
				rvSupport = "both"
			},

			["86fordE150pd"] = {
				vehicles = {
				    vans = {
				        "86fordE150pd",
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
					},					

				},			
				rvSupport = "both"
			},

			["rSemiTruck"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				        "Base.SemiTruckBox",
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
				        "Base.SemiTruck",						
					},

				},				
				rvSupport = "both"
			},

			["ATA_Petyarbuilt"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				    },

				    bigRVs = {
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },

					semiTrucks = {
				        "Base.ATAPetyarbuilt",
				        "Base.ATAPetyarbuiltSleeper",
				        "Base.ATAPetyarbuiltSleeperLong",						
					},					

				},				
				rvSupport = "PRI"
			},

			["SpecialEmergencyVehiclesFRsm"] = {
				vehicles = {
				    vans = {
				    },

				    stepVans = {
				    },

				    camperRVs = {
				        "Base.86econolinervFBIMHQLG",
				        "Base.86econolinervLVMHQLG",
				    },

				    bigRVs = {
				        "Base.86bounderHAzardmaterials",
				    },

				    boxTrucks = {
				    },

				    buses = {
				    },

				    utility = {
				    },
					
					semiTrucks = {
					},	
				}
			},
			rvSupport = "both"
		},
	},


	--//Trailers//--
	trailers = {
		vanilla = {
			utility = {
				"Base.Trailer",
				"Base.Trailer_Horsebox",
				"Base.Trailer_Livestock",
			},

			semi = {
			},

			camperTrailers = {
			},
		},

		mods = {

			["FRUsedCarsAlpha"] = {
				trailers = {
					utility = {
						"Base.Trailer_fr_moving_large",
						"Base.Trailer_fr_moving_medium",
					},

					semi = {
						"Base.Trailer_fr_semi_container",
						"Base.Trailer_fr_semi_van",
					},

					camperTrailers = {
						"Base.Trailer_fr_camper_scamp",
					},
				},
				rvSupport = "both",
			},

			["PzkVanillaPlusCarPack"] = {
				trailers = {
					utility = {
					},

					semi = {
					},

					camperTrailers = {
						"Base.pzkTrailerCamping",
					},
				},
				rvSupport = "both",
			},

			["KI5trailers"] = {
				trailers = {
					utility = {
						"Base.TrailerKI5cargoLarge",
					},

					semi = {
					},

					camperTrailers = {
					},
				},
				rvSupport = "both",
			},

			["autotsartrailers"] = {
				trailers = {
					utility = {
					},

					semi = {
					},

					camperTrailers = {
						"Base.TrailerHome",
						"Base.TrailerHomeExplorer",
						"Base.TrailerHomeHartman",
					},
				},
				rvSupport = "both",
			},

			["CytU1550L"] = {
				trailers = {
					utility = {
						"Base.UnimogTrailer",
					},

					semi = {
					},

					camperTrailers = {
					},
				},
				rvSupport = "both",
			},

			["rSemiTruck"] = {
				trailers = {
					utility = {
					},

					semi = {
						"Base.SemiTrailerVan",
					},

					camperTrailers = {
					},
				},
				rvSupport = "both",
			},

			["ATA_Petyarbuilt"] = {
				trailers = {
					utility = {
					},

					semi = {
						"Base.TrailerTSMega",
						-- "Base.TrailerTSMegaAnimal",
					},

					camperTrailers = {
					},
				},
				rvSupport = "PRI",
			},
		}
	}
}

return vehicles_list